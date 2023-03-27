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
#             AEG1  4444  NM
#     after :
#             Plot  Biomass2008 Biomass2009
#             AEG1  0.1         0.2

#             In the year "4444", there was no measure on Biomass, therefore this function-year
#               combination is removed.

##
# requirements
# - dataset 27087 with attachements from bexis
#    - attachments : "synthesis_grassland_function_metadata_ID27087.csv" is used for the conversion.

##
# install required packages
install.packages("data.table")
install.packages("reshape2")


##
# load required packages
library(data.table)
library(reshape2)

##
# load datasets
# path_to_bexis_datasets <- "" # fill in path to the BExIS dataset.
# loading metadata
path_to_bexis_datasets <- "~/Downloads/27087_24_Dataset/"
additional_info <- fread(paste(path_to_bexis_datasets, "synthesis_grassland_function_metadata_ID27087.csv", sep = ""))
additional_info <- additional_info[, .(ColumnName, AggregatedColumnName, codedYear)]
setnames(additional_info, old = c("ColumnName", "codedYear"), new = c("variable", "Year"))
# loading dataset
original_synth_func <- fread(paste(path_to_bexis_datasets, "27087_24_data.csv", sep = ""))
# in case the two columns below exist, take away
original_synth_func[, Soil_depth := NULL]
original_synth_func[, Soil_C_concentration := NULL]
# remove year == 4444 values (year == 444444 replaced year = 4444)
original_synth_func <- original_synth_func[Year != "4444", ]

##
# get function-year combinations as columns
# make format even longer to obtain a column "Year" and a column "function"
synth_func <- data.table(melt(original_synth_func, id.vars = c("Plot", "Plotn", "Explo", "Year")))
sum(is.na(synth_func$value))
# delete all missing function-year combinations (without excluding NA values)
synth_func <- synth_func[!value %in% "NM"]
sum(is.na(synth_func$value))

synth_func <- merge(synth_func, additional_info, by = c("variable", "Year"))
synth_func <- synth_func[, .(AggregatedColumnName, Plot, Plotn, Explo, value)]
synth_func <- data.table(dcast(synth_func, Plot + Plotn + Explo ~ AggregatedColumnName, value.var = "value"))

##
# quality control
# select some random functions from the old format and the new format and visually
#    check if the values are still exactly the same (perfect correlation).
# synth_func is the newly created dataset, original_synth_func is the read in dataset
#   taking out "NM" from the original.
plot(synth_func[, Total.pollinators], original_synth_func[!Total_pollinators %in% "NM", Total_pollinators])
plot(synth_func[, Urease], original_synth_func[!Urease %in% "NM", Urease])
plot(synth_func[, amoA_AOA.2016], original_synth_func[Year == "2016",][!amoA_AOA %in% "NM", amoA_AOA])
plot(synth_func$Groundwater.recharge2013, original_synth_func[Year == 2013, Groundwater_recharge])
plot(synth_func[, Soil.C.stock], original_synth_func[!Soil_C_stock %in% "NM", Soil_C_stock])
# quality control successful?

##
# save reformatted file
fwrite(synth_func, file = "bexis_to_wide_format_output.txt", sep = ";")
