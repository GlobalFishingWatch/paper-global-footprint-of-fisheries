# Fishing Vessels

## Fishing Vessels Included in Fishing Effort Data

These data are available in the following formats:
 - BigQuery Tables
 - CSVs

Links to these data are available at [Global Fishing Watch's community page](https://globalfishingwatch.force.com/gfw/s/data_download).

For additional information about these results, see the associated journal article: [D.A. Kroodsma, J. Mayorga, T. Hochberg, N.A. Miller, K. Boerder, F. Ferretti, A. Wilson, 7 B. Bergman, T.D. White, B.A. Block, P. Woods, B. Sullivan, C. Costello, and B. Worm. "Tracking the global footprint of fisheries." Science 361.6378 (2018).](http://science.sciencemag.org/cgi/doi/10.1126/science.aao1118)

License: [Creative Commons Attribution-ShareAlike 4.0 International license](https://creativecommons.org/licenses/by-sa/4.0/)

For updates, links to example code, and more, visit:

 - [Global Fishing Watch R&D Site](globalfishingwatch.io/global-footprint-of-fisheries.html)
 - [GitHub Repo for Tracking the Global Footprint of Fisheries](GitHub.com/globalfishingwatch/tracking-global-footprint-of-fisheries)

Description: This table includes all mmsi that are included in the [fishing effort data](https://github.com/GlobalFishingWatch/global-footprint-of-fisheries/blob/master/data_documentation/fishing_effort.md). It includes all vessels that were identified as fishing vessels by the neural network and which were not identified as non-fishing vessels by registries and manual review. If an mmsi was matched to a fishing vessel on a registry, but the neural net did not classify it as a fishing vessel, it is not included on this list. There is only one row for each mmsi. 

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
 - length: best value for length overall in meters
 - tonnage: best value for gross tonnage
 - engine_power: best value for main engine power, in kilowatts
 - active_2012: If this mmsi was active in 2012
 - active_2013: If this mmsi was active in 2013
 - active_2014: If this mmsi was active in 2014
 - active_2015: If this mmsi was active in 2015
 - active_2016: If this mmsi was active in 2016
