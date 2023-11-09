# Synthesis_dataset_functions_grassland
Released at Zenodo : [![DOI](https://zenodo.org/badge/181692075.svg)](https://zenodo.org/badge/latestdoi/181692075)

former name : 2019_grassland_functions

Code used for generation of the synthesis grassland function dataset [BExIS ID 27087](https://www.bexis.uni-jena.de/ddm/data/showdata/27087).

### License

This project is licensed under the terms of the Creative Commons Attribution 4.0 license (cc-by-4.0).

# Versions

- March 2023 Major update (in dataset) : Error in Biomass data found : in assembled biomass dataset 31448, 2014 was completely wrong, plus smaller errors found in : 2018 (9 plots in HAI) and 2019 (very small differences in some HAI and some SCH plots).
  The assembled biomass was not used for the functions dataset, thus the 2014 error did not affect this grassland functions dataset 27087. But the other years are corrected with the new dataset 31448. The Biomass years 2009 - 2017 were taken from 31448 now, instead of taking the individual years (because the small errors were not corrected in the individual years). Thus, the citations strings were updated as well, adding the assembled dataset 31448 as source while keeping the individual year's sources as well.

# Scripts

**Table of contents** : 

- `1read_raw_dataset.Rmd` : to read in raw data. Start with this file, after you downloaded all required datasets from Bexis and unzipped them. It contains minor calculations, but mostly it contains code to clean and format the data for the next script.
- `2calc_raw_dataset.Rmd`  : It takes the output from file 1, and calculates the functions dataset from it. Finally, it saves the constructed functions dataset as a .csv file under a name of your choice. *Note*: the part with saving output is outcommented (eval=F). Please run manually or enable automatic running (setting eval=T).
- `input_for_2calc.R` : An R script which can be run before calculating mini-multifunctionalities. It checks the correlations between functions and performs a PCA.
- `3explore_functions_dataset.R` : An example of how to explore missing data and correlations in the previously generated dataset.
- `multidiversity.R` : contains required function. Is sourced by the above file.



### BExIS upload

- `bring_to_bexis_format.R` : applies formatting changes needed for bexis upload (e.g. column "Year" instead of having each function-year combination (e.g. Biomass.2008, Biomass.2009) in separate columns). Decreases number of columns but increases number of (empty) rows.
- `generate_format_colnames_years_key.csv.R` generates the output:`format_colnames_years_key.csv`
- `27626_bexis_to_wide_format` : changes back the applied format changes to the original format. Is uploaded separately as well.

### additional scripts

- `create_27087_helper_from_additional_metadata.R` : creates the helper table "27087_helper.csv" from the additional metadata file : "synthesis_grassland_function_metadata_ID27087.csv"
- `soil_N_processes_minimultifunctionality_considerations.Rmd` : considerations for function selection





## Next update

For the next update, following new datasets can be included (need to be checked if actually fitting):
- Arthropods (core) project
  - Dung and seed depletion (only VIPs), e.g. in 2020 (30938)
  - temporal arthropod dataset (see BetaDivMultifun notes)
- SCALEMIC
  - Soil enzyme activities of all grassland EPs, soil sampling campaign (SSC) 2017, SCALEMIC (26147)
  - Physico-chemical soil properties 2017 (25586)
  - Microbial soil properties 2017 (25408)
- 17086 : Soil dataset also has N concentrations measured, which can be used to build an N stock measure. Could add that.
- Soil C stock : check if 2014 dataset is included (BExIS ID20266), include OC stock 2017 and (if already uploaded) 2021 
- Biomass of new years (+ other vars from new years)
- Dung removal and NO3.2004 have negative values, because different dung types were scaled in order to aggregate them. --> In future, think about how to avoid negative values. (units are e.g. g/m^2). Note (2023) : in the forest functions dataset, values were scaled with scale(..., center = F, scale = T) i.e. were not centered, but scaled which lead to values > 0 (for input values >0)
- Soil respiration 2018 and 2019, Apostolakis, Schöning, Schrumpf, Klötzing, Trumbore
- Soil-depth was added, could not be added to BExIS yet but please add at next update (once the data structure can be added)
- PRI and NRI do NOT contain any root nutrient measure (no root P and no root N). Check if this is available in BExIS and if yes, include to NRI and PRI variable. Note : (1) maybe Norbert Hölzl measured it (maybe just in VIPs or MIPs?) (2) maybe calculate PRI with root data and check how correlated it is with incomplete PRI
