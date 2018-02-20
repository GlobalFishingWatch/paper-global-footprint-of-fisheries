# Vessel

## Results of Nerual Net Classifier and MMSI Matched to Registries

These data are available in the following formats:
 - BigQuery Tables
 - CSVs

Links to these data are available at [Global Fishing Watch's community page](https://globalfishingwatch.force.com/gfw/s/topic/0TO36000000PXJdGAO/global-fishing-watch-data).

Data citation: Kroodsma et al. "Tracking the global footprint of fisheries." Science 361.6378 (2018):XXX-XXX.
License:  [Creative Commons Attribution-ShareAlike 4.0 International license](https://creativecommons.org/licenses/by-sa/4.0/)

For updates, links to example code, and more, visit:
(globalfishingwatch.io/global-footprint-of-fisheries.html)[globalfishingwatch.io/global-footprint-of-fisheries.html] and 
[GitHub.com/globalfishingwatch/global-footprint-of-fisheries.html](GitHub.com/globalfishingwatch/global-footprint-of-fisheries.html)

This table includes all mmsi that were matched to a vessel regsitry, which were identified through manual review or web searchers, or which were classified by the neural network. MMSI that are not included did not have enough activity during our time period (2012 to 2016) to be classified by our neural network (had to have at least 500 positions over a six month period).

If an mmsi matched to multiple vessels, that mmsi is repeated in this table.  


## Table Schema
 - mmsi: Maritime Mobile Service Identity, the identifier for AIS
 - shipname: If this mmsi was matched to a vessel registry, the name that matched to the registry
 - callsign: If this mmsi was matched to a vessel registry, the International Radio Call Sign value that was matched
 - flag: an iso3 value for the flag state of the vessel. Only for vessels that have been matched to registries or have known values.
 - imo: If this mmsi was matched to a vessel registry, the Internationa Maratime Organization number that matched to the registry
 - registry_geartype: If this mmsi was matched to a vessel registry, and the vessel regisgtry included geartype, the geartype from the registry
 - inferred_geartype: the geartpye inferred by the neural network. If this value is null, it means the vessel did not have enough activity to be classified by the neural network. Possible geartypes include:
   - tug
   - gear
   - trawlers
   - purse_seines
   - squid_jigger
   - seismic_vessel
   - cargo_or_tanker
   - passenger
   - fixed_gear
   - other_fishing
   - reefer
   - drifting_longlines
 - inferred_geartype_score: the "score" from the neural network. Closer to 1 means that the neural network was more confident, although this is not a probability score. 
 - inferred_subgeartype: in subgeartype inferred by the neural network. These are the same as the geartypes, except for the following:
   - cargo --> cargo_or_tanker
   - tanker --> cargo_or_tanker
   - set_gillnets --> fixed_gear
   - set_longlines --> fixed_gear
   - pots_and_traps --> fixed_gear
   - motor_passenger --> passenger
   - sailing --> passenger
   - trollers --> other_fishing
   - pole_and_line --> other_fishing
   - other_fishing --> other_fishing (other fishing in subgeartype includes all other types of fishing vessels, and in the geartype, it includes all of these plus pole and line and trollers)
  - other_not_fishing --? JAEYOON WHERE DID THIS COME FROM?
 - inferred_subgeartype_score: the "score" from the neural network. Closer to 1 means that the neural network was more confident, although this is not a probability score.
 - registry_length: Length overall in meters from regsitries, if this mmsi has been matched to a registry and has a length from the registry.
 - inferred_length: Length, in meters, inferred by the neural network
 - registry_tonnage: Gross tonnage of vessel from registries, if this mmsi has been matched to a registry and has a gross tonnage listed. 
 - inferred_tonnage: Gross tonnage of vessel inferred from the neural network. 
 - registry_engine_power: Engine power in kilowatts of vessel from registries, if this mmsi has been matched to a registry and has an engine power listed.
 - inferred_engine_power: Main engine power, in kilowatts, inferred by the neural network.	
 - source: A list of all registries that this mmsi was matched to. These lists include:
  - REVIEW: all human manual review or correction values
  - CCAMLR, CLAV, FFA, IATTC, ISSF, ITU, IUU, NPFC, SPRFMO WCPFC: values from respective organizations
  - CAN, EU, ISL, KOR, NOR, RUS, USA: values from respestive countries in iso3 code (or economic blocks) national vessel registry
