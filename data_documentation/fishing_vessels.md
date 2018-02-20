# Fishing Vessels

## Fishing Vessels Included in Fishing Effort Data

These data are available in the following formats:
 - BigQuery Tables
 - CSVs

Links to these data are available at [Global Fishing Watch's community page](https://globalfishingwatch.force.com/gfw/s/topic/0TO36000000PXJdGAO/global-fishing-watch-data).

Data citation: Kroodsma et al. "Tracking the global footprint of fisheries." Science 361.6378 (2018):XXX-XXX.

License:  [Creative Commons Attribution-ShareAlike 4.0 International license](https://creativecommons.org/licenses/by-sa/4.0/)

For updates, links to example code, and more, visit:
globalfishingwatch.io/global-footprint-of-fisheries.html
GitHub.com/globalfishingwatch/tracking-global-footprint-of-fisheries

This table includes all mmsi that are included in the fishing effort data. It includes all vessels that were identified as fishing vessels by the neural network and which were not identified as non-fishing vessels by registries and manual review. If an mmsi was matched to a fishing vessel on a registry, but the neural net did not classify it as a fishing vessel, it is not included on this list. There is only one row for each mmsi. 

## Table Schema
 - mmsi: Maritime Mobile Service Identity, the identifier for AIS
 - flag: An iso3 value for the flag state of the vessel. If we did not have a value from a manual review or from matching the vessels to registries, we used the MMSI mid code to identify the vessel flag state. A value of "UNK" means the flag state is unknown. 
 - geartype: Best value for geartype. Options include:
   - trawlers
   - purse_seines
   - squid_jigger
   - fixed_gear
   - other_fishing
   - drifting_longlines
 - subgeartype: best value subgeartype.
 - length: best value for length overall in meters
 - tonnage: best value for gross tonnage
 - engine_power: best value for main engine power, in kilowatts
 - active_2012: If this mmsi was active in 2012
 - active_2013: If this mmsi was active in 2013
 - active_2014: If this mmsi was active in 2014
 - active_2015: If this mmsi was active in 2015
 - active_2016: If this mmsi was active in 2016
