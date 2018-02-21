## Export public bigquery tables to GCS

NOTE: the fishing_effort table is large, so the export takes a while.  It is recommended to clone this repo on a GCE instance and run it there using `screen`


To export the public tables to GCS

1. Edit the config.sh to point to the right locations (you might want to run it against a temp location the first time)

2. run export_table.sh and specify which table you want to export.  Run the scritp with no argumentes to get a list of supported tables

For example

```bash
$ ./export_table.sh 
usage:  export_table TARGET

  valid targets:
    fishing_effort
    fishing_effort_byvessel
    fishing_vessels
    vessels
```

To export the fishing_effort table
```bash
$ ./export_table fishing_effort
```

