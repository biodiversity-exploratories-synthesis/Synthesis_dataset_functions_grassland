# 2019_grassland_functions

Code used for generation of the 2019 synthesis grassland function dataset.

**Table of contents** : 
- `1read_raw_dataset.Rmd` : to read in raw data. Start with this file, after you downloaded all required datasets from Bexis and unzipped them. It contains minor calculations, but mostly it contains code to clean and format the data for the next script.
- `2calc_raw_dataset.Rmd`  : It takes the output from file 1, and calculates the functions dataset from it. Finally, it saves the constructed functions dataset as a .csv file under a name of your choice. *Note*: the part with saving output is outcommented (eval=F). Please run manually or enable automatic running (setting eval=T).
- `input_for_2calc.R` : An R script which can be run before calculating mini-multifunctionalities. It checks the correlations between functions and performs a PCA.
- `3explore_functions_dataset` : An example of how to explore missing data and correlations in the previously generated dataset.
- `multidiversity.R` : contains required function. Is sourced by the above file.



### BExIS upload

- `bring_to_bexis_format.R` : applies formatting changes needed for bexis upload (e.g. column "Year" instead of having each function-year combination (e.g. Biomass.2008, Biomass.2009) in separate columns). Decreases number of columns but increases number of (empty) rows.
-  `generate_format_colnames_years_key.csv.R` generates the output:`format_colnames_years_key.csv`

- `27626_bexis_to_wide_format` : changes back the applied format changes to the original format