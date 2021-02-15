#####################################
#
# Bring 27088 to wide format
#
#####################################
# by Noelle Schenk

##
# goals of the script : 
#  - reformat bexis dataset to a wide format where all measured functions (from several years)
#     are listed in separate columns
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
# - dataset 27087 and 27088 from bexis
#    - dataset 27088 : open the excel sheet "synthesis_grassland_function_metadata_ID27088",
#          convert the first tab "synthesis_grassland_function_metadata_ID26726" to csv
#          WITH ; AS DELIMINER (because "," is used within cells).
#          this new .csv file is used for the conversion.

##
# install required packages
install.packages("data.table")
install.packages("reshape2")


##
# load required packages
require(data.table)
require(reshape2)

##
# load datasets
# path_to_bexis_datasets <- "" # fill in path to the BExIS dataset.
additional_info <- fread(paste(path_to_bexis_datasets, "27088_Additional metadata of dataset 27087 Assembled ecosystem measures from grassland EPs (2008-2018) for multifunctionality synthesis - June 2020/synthesis_grassland_function_metadata_ID27088.csv", sep = ""))
additional_info <- additional_info[, .(ColumnName, AggregatedColumnName, codedYear)]
setnames(additional_info, old = c("ColumnName", "codedYear"), new = c("variable", "Year"))
original_synth_func <- fread(paste(path_to_bexis_datasets, "27087_Assembled ecosystem measures from grassland EPs (2008-2018) for multifunctionality synthesis - June 2020_4.1.15/27087.txt", sep = ""))

##
# get function-year combinations as columns
# make format even longer to obtain a column "Year" and a column "function"
synth_func <- melt(original_synth_func, id.vars = c("Plot", "Plotn", "Explo", "Year"))
sum(is.na(synth_func$value))
# delete all missing function-year combinations (without excluding NA values)
synth_func <- synth_func[!value %in% "NM"]
sum(is.na(synth_func$value))

synth_func <- merge(synth_func, additional_info, by = c("variable", "Year"))
synth_func <- synth_func[, .(AggregatedColumnName, Plot, Plotn, Explo, value)]
synth_func <-dcast(synth_func, Plot + Plotn + Explo ~ AggregatedColumnName, value.var = "value")

##
# quality control
# select some random functions from the old format and the new format and visually
#    check if the values are still exactly the same (perfect correlation).
# synth_func is the newly created dataset, original_synth_func is the read in dataset
plot(synth_func$Total.pollinators, original_synth_func[!Total_pollinators %in% "NM", Total_pollinators])
plot(synth_func$Urease, original_synth_func[!Urease %in% "NM", Urease])
plot(synth_func$amoA_AOA.2016, original_synth_func[Year == "2016", amoA_AOA])
plot(synth_func$Groundwater.recharge2013, original_synth_func[Year == 2013, Groundwater_recharge])
plot(synth_func$Soil.C.stock, original_synth_func[!Soil_C_stock %in% "NM", Soil_C_stock])
# quality control successful?

##
# save reformatted file
fwrite(synth_func, file = "27087_reformatted.csv", sep = ";")