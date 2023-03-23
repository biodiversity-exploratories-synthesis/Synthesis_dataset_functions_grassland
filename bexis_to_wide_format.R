#####################################
#
# Bring downloaded dataset to wide format
#
#####################################
# by Noelle Schenk
# last edit : 05.01.22

##
# goals of the script : 
#  - reformat bexis dataset to a wide format (all functions for every year in separate columns)
# example (with invented values): 
#     before : 
#             Plot  Year  Biomass
#             AEG1  2008  0.1
#             AEG1  2009  0.2
#             AEG1  444444  NM
#     after :
#             Plot  Biomass2008 Biomass2009
#             AEG1  0.1         0.2

#             In the year "444444", there was no measure on Biomass, therefore this function-year
#               combination is removed.

##
# Note about solved issue (4444 vs. 444444):
# Originally, the value "4444.0" was used to encode for assembled functions.
# Later, this was change to "444444.0" (2 digits more), to be even clearer.
# Rows can not be deleted from uploaded datasets in BExIS version updates.
# Therefore, all rows with Year == "4444.0" are set to "NM"= "not measured".
# This automatically removes all entries for year "4444.0", keeping the entries
# for year "444444.0" with the assembled yers.

##
# requirements
# - dataset 27087 with attachements from bexis
#    - attachments : "synthesis_grassland_function_metadata_ID27087.csv" is used for the conversion.

## GET REQUIREMENTS ----
# install required packages
install.packages("data.table")
install.packages("reshape2")
library(data.table)
library(reshape2)
### load datasets
path_to_bexis_datasets <- "~/Document/Project1/" # fill in path to the BExIS dataset.
# metadata info
additional_info <- fread(paste(path_to_bexis_datasets, "synthesis_grassland_function_metadata_ID27087.csv", sep = ""))
additional_info <- additional_info[, .(ColumnName, AggregatedColumnName, codedYear)]
setnames(additional_info, old = c("ColumnName", "codedYear"), new = c("variable", "Year"))
# dataset
original_synth_func <- fread(paste(path_to_bexis_datasets, "27087_25_data.csv", sep = ""))


## TRANSFORM ----
# get function-year combinations as columns
# make format even longer to obtain a column "Year" and a column "function"
synth_func <- data.table(melt(original_synth_func, id.vars = c("Plot", "Plotn", "Explo", "Year")))
sum(is.na(synth_func$value))
# delete all missing function-year combinations (without excluding NA values)
synth_func <- synth_func[!value %in% "NM"]
# Note that this will automatically take out all entries for year "4444.0" 
#    (keeping the entries for year "444444.0")
sum(is.na(synth_func$value))

synth_func <- merge(synth_func, additional_info, by = c("variable", "Year"))
synth_func <- synth_func[, .(AggregatedColumnName, Plot, Plotn, Explo, value)]
synth_func <- data.table(dcast(synth_func, Plot + Plotn + Explo ~ AggregatedColumnName, value.var = "value"))


## QUALITY CONTROL ----
# select some random functions from the old format and the new format and visually
#    check if the values are still exactly the same (perfect correlation).
# synth_func is the newly created dataset, original_synth_func is the read in dataset
#   taking out "NM" from the original and "NA" from the wide format.
plot(as.numeric(synth_func[!is.na(Total.pollinators), Total.pollinators]), 
     as.numeric(original_synth_func[!Total_pollinators %in% c("NM", NA), Total_pollinators]))
plot(as.numeric(synth_func[!is.na(Urease), Urease]),
     as.numeric(original_synth_func[!Urease %in% c("NM", NA), Urease]))
plot(as.numeric(synth_func[!is.na(amoA_AOA.2016), amoA_AOA.2016]),
     as.numeric(original_synth_func[Year == "2016",][!amoA_AOA %in% c("NM", NA), amoA_AOA]))
plot(synth_func$Groundwater.recharge2013, 
     original_synth_func[Year == 2013, Groundwater_recharge])
plot(synth_func[!is.na(Soil.C.stock), Soil.C.stock], 
     original_synth_func[!Soil_C_stock %in% c(NA, "NM"), Soil_C_stock])
# quality control successful?


## SAVE NEW FILE ----
fwrite(synth_func, file = "bexis_to_wide_format_output.csv", sep = ";")
