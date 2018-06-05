# Fishing Effort

## Daily Fishing Effort and Vessel Presence at 100th Degree Resolution by Flag State and GearType, 2012-2016

Fishing effort and vessel presence data is avaialbe in the following formats:
 - BigQuery Tables
 - CSVs
 - Geotiff Rasters in Google Earth Engine

Links to these data are available at [Global Fishing Watch's community page](https://globalfishingwatch.force.com/gfw/s/data_download).

For additional information about these results, see the associated journal article: [D.A. Kroodsma, J. Mayorga, T. Hochberg, N.A. Miller, K. Boerder, F. Ferretti, A. Wilson, B. Bergman, T.D. White, B.A. Block, P. Woods, B. Sullivan, C. Costello, and B. Worm. "Tracking the global footprint of fisheries." Science 361.6378 (2018).](http://science.sciencemag.org/content/359/6378/904)

For updates, links to example code, and more, visit:

 - [Global Fishing Watch R&D Site](http://globalfishingwatch.io/global-footprint-of-fisheries.html)
 - [GitHub Repo for Tracking the Global Footprint of Fisheries](https://github.com/GlobalFishingWatch/global-footprint-of-fisheries/tree/master/data_documentation)

Description: Fishing effort and vessel presence is binned into grid cells 0.01 degrees on a side, and measured in units of hours. The time is calculated by assigning an amount of time to each AIS detection (which is half the time to the previous plus half the time to the next AIS position), and then summing all positions in each grid cell. Data is based on fishing detections of >70,000 unique AIS devices on fishing vessels. Fishing vessels are identified via a neural network classifier and vessel registry databases. Fishing effort for squid jiggers is not calculated through the neural network, but instead through [this heuristic](https://github.com/GlobalFishingWatch/global-footprint-of-fisheries/blob/master/data_production/updated-algorithm-for-squid-jiggers.md). The neural net classifies fishing vessels into six categories:

 - drifting_longlines: drifting longlines
 - purse_seines: purse seines, both pelagic and demersal
 - trawlers: trawlers, all types
 - fixed_gear: a category that includes set longlines, set gillnets, and pots and traps 
 - squid_jigger: squid jiggers, mostly large industrial pelagic operating vessels
 - other_fishing: a combination of vessels of unknown fishing gear and other, less common gears such as trollers or pole and line 


## Table Schema
 - date: a string in format “YYYY-MM-DD” 
 - lat_bin: the southern edge of the grid cell, in 100ths of a degree -- 101 is the grid cell with a southern edge at 1.01 degrees north
 - lon_bin: the western edge of the grid cell, in 100ths of a degree -- 101 is the grid cell with a western edge at 1.01 degrees east
 - flag: the flag state of the fishing effort, in iso3 value
 - geartype: see our description of geartpyes
 - vessel_hours: hours that vessels of this geartype and flag were present in this gridcell on this day
 - fishing_hours: hours that vessels of this geartype and flag were fishing in this gridcell on this day
 - mmsi_present: number of mmsi of this flag state and geartype that visited this grid cell on this day 	
