# Fishing Effort by Vessel

## Daily Fishing Effort at 10th Degree Resolution by MMSI, 2012-2016

Fishing effort and vessel presence data is avaialbe in the following formats:
 - BigQuery Tables
 - CSVs

Links to these data are available at [Global Fishing Watch's community page](https://globalfishingwatch.force.com/gfw/s/data_download).

For additional information about these results, see the associated journal article: [D.A. Kroodsma, J. Mayorga, T. Hochberg, N.A. Miller, K. Boerder, F. Ferretti, A. Wilson, 7 B. Bergman, T.D. White, B.A. Block, P. Woods, B. Sullivan, C. Costello, and B. Worm. "Tracking the global footprint of fisheries." Science 361.6378 (2018).](http://science.sciencemag.org/cgi/doi/10.1126/science.aao1118)

For updates, links to example code, and more, visit:

 - [Global Fishing Watch R&D Site](globalfishingwatch.io/global-footprint-of-fisheries.html)
 - [GitHub Repo for Tracking the Global Footprint of Fisheries](GitHub.com/globalfishingwatch/tracking-global-footprint-of-fisheries)

Description: Fishing effort is binned into grid cells 0.1 degrees on a side, and measured in units of hours. The time is calculated by assigning an amount of time to each AIS detection (which is half the time to the previous plus half the time to the next AIS position). To get information on each mmsi, see Global Fishing Watch data on [fishing vessels](https://github.com/GlobalFishingWatch/Tracking-the-Global-Footprint-of-Fisheries/blob/master/data_documentation/fishing_vessels.md).

## Table Schema
 - date: a string in format “YYYY-MM-DD” 
 - mmsi: unique AIS identifier
 - lat_bin: the southern edge of the grid cell, in 10ths of a degree -- 101 is the grid cell with a southern edge at 10.1 degrees north
 - lon_bin: the western edge of the grid cell, in 10ths of a degree -- 101 is the grid cell with a western edge at 10.1 degrees east
 - fishing_hours: hours that vessels of this geartype and flag were fishing in this gridcell on this day
