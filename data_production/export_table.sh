#!/usr/bin/env bash
set -e

THIS_SCRIPT_DIR="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"

source ${THIS_SCRIPT_DIR}/config.sh

display_usage() {
	echo "usage:  export_table TARGET"
	echo ""
	echo "  valid targets:"
	echo "    fishing_effort"
	echo "    fishing_effort_byvessel"
	echo "    fishing_vessels"
	echo "    vessels"
	}

case $1 in

  fishing_effort)
    TARGET=$1
    PARTITION=1
    ;;

  fishing_effort_byvessel)
    TARGET=$1
    PARTITION=1
    ;;

  fishing_vessels)
    TARGET=$1
    PARTITION=
    ;;

  vessels)
    TARGET=$1
    PARTITION=
    ;;

  *)
    display_usage
    exit 0
    ;;
esac


BQ_TABLE=${PROJECT}:${DATASET}.${TARGET}
README=${THIS_SCRIPT_DIR}/../data_documentation/${TARGET}.md
GCS_TEMP_BUCKET=gs://${TEMP_BUCKET}
GCS_DEST_DIR=gs://${BUCKET}/${TARGET}

TEMP_DIR=$(mktemp -d)

LOCAL_EXTRACT_DIR=${TEMP_DIR}/extract
LOCAL_PARTITION_DIR=${TEMP_DIR}/partition
LOCAL_DEST_DIR=${TEMP_DIR}/${TARGET}

if [ -z ${PARTITION} ]; then
    LOCAL_CSV_DIR=${LOCAL_DEST_DIR}
else
    LOCAL_CSV_DIR=${LOCAL_DEST_DIR}/daily_csvs
fi


mkdir -p ${TEMP_DIR}
mkdir -p ${LOCAL_EXTRACT_DIR}
mkdir -p ${LOCAL_PARTITION_DIR}
mkdir -p ${LOCAL_DEST_DIR}
mkdir -p ${LOCAL_CSV_DIR}

UUID=$(uuidgen)

GCS_EXTRACT_DIR=${GCS_TEMP_BUCKET}/${UUID}
CSV_HEADER=${TEMP_DIR}/header

echo "Export Bigquery table to temp gcs location"
echo ""
bq extract \
    --compression GZIP \
    --destination_format CSV \
    ${BQ_TABLE} \
    ${GCS_EXTRACT_DIR}/extract*.csv.gz


echo ""
echo "Copy the extracted files to a local temp dir"
echo ""
gsutil -m cp ${GCS_EXTRACT_DIR}/* ${LOCAL_EXTRACT_DIR}

echo ""
echo "Get the first line from the first file (csv header)"
echo ""

echo $(cat $(ls -d1 ${LOCAL_EXTRACT_DIR}/* | head -1) | gunzip | head -1) > ${CSV_HEADER}

echo ""
echo "Parition csv files by date"
echo ""
#partition the csv files by date (the first field), and ignore the first line (header)"
for f in ${LOCAL_EXTRACT_DIR}/*
do
  echo $f
  if [ -z ${PARTITION} ]; then
    cat $f | gunzip | tail -n+2 >> ${LOCAL_PARTITION_DIR}/${TARGET}.csv
  else
    cat $f | gunzip | tail -n+2 | awk -F, '{print >> ("'${LOCAL_PARTITION_DIR}'/"$1".csv")}'
  fi
done

echo ""
echo "Add csv headers"
echo ""
# combine the csv header with the partitioned data
for f in ${LOCAL_PARTITION_DIR}/*
do
  echo $f
  CSV_FILE=${LOCAL_CSV_DIR}/$(basename $f)
  cat $CSV_HEADER $f > ${CSV_FILE}
done

echo ""
echo "Create the readme"
echo ""
echo "${README}"
sed -E 's/[#]+[ ]?//g; s/\[//g; s/\]/ /g;' ${README} > ${LOCAL_DEST_DIR}/readme.txt

echo ""
echo "Combine into a single zip file"
echo ""

# make a single zip with all the csvs in it
cd ${TEMP_DIR}
zip -r ${TARGET}/${TARGET}.zip ${TARGET}/*
cd ..

echo ""
echo "gzip individual day files"
echo ""

# gzip individual csv files
gzip ${LOCAL_CSV_DIR}/*.csv

echo ""
echo "Upload everything to GCS"
echo ""
# upload the whole mess to GCS
gsutil -m cp -r ${LOCAL_DEST_DIR}/* ${GCS_DEST_DIR}/

# clean up temp dir
rm -rf ${TEMP_DIR}
