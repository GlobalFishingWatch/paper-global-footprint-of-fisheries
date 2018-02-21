#!/usr/bin/env bash

# PROJECT  is the GCP project ID where the bigquery tables are stored
# DATASET  is the bigquery data set containing the tables
# BUCKET   is the GCS bucket where the export will be stored
# TEMP_BUCKET  is used for intermediate storage of the extract from bigquery


# Sample test settings
PROJECT=world-fishing-827
DATASET=scratch_paul_ttl_100
BUCKET=scratch-paul-ttl100
TEMP_BUCKET=scratch-paul-ttl100


# Production settings
#PROJECT=global-fishing-watch
#DATASET=global_footprint_of_fisheries
#BUCKET=global_footprint_of_fisheries
#TEMP_BUCKET=scratch-paul-ttl100
