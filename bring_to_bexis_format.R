#######################
#
# BExIS FORMAT
#
#######################
#
# Created : around June 2022 or before by noelle, last edit : 23.03.23 by noelle
# AIM : change the wide format of raw_functions as created by 1read_raw_dataset.Rmd and 2calc_raw_dataset.Rmd
#    to long format as used to store in BExIS.

# Requirements
require(data.table)
# helper dataset with names
varkey <- fread("format_colnames_years_key.csv")
# synthesisdataset <- fread("<path-to-synthesis-dataset>/jan2022_raw_functions_dataset.csv")
synthesisdataset <- data.table::copy(raw_functions) # if output from 2calc_raw_dataset.Rmd is still in environment

# convert numeric column to numeric
num <- colnames(synthesisdataset)[!colnames(synthesisdataset) %in% c("Plot", "Plotn", "Explo")]
synthesisdataset[, (num) := lapply(.SD, as.numeric), .SDcols = num]
rm(num)

synthesisdataset <- data.table(melt(synthesisdataset, id = c("Plot", "Plotn", "Explo")))
setnames(synthesisdataset, old = "variable", new = "oldnames")

# check if all names are referred to in varkey
all(unique(synthesisdataset$oldnames) %in% varkey$oldnames)
all(varkey$oldnames %in% unique(synthesisdataset$oldnames))
varkey$oldnames[which(!varkey$oldnames %in% unique(synthesisdataset$oldnames))] # only Explo, Plot and Plotn --> no problem

synthesisdataset <- merge(synthesisdataset, varkey[, .(oldnames, short_varname, Year)], by = "oldnames")
synthesisdataset[, oldnames := NULL]
# Data type "double" allows up to 15 digits behind the comma. Round all values to 14 digits.
synthesisdataset[, value := round(value, 7)]
# AMOA_AOA and AOB have very large numbers --> round to 3 digits
synthesisdataset[short_varname == "amoA_AOA", value := round(value, 3)]
synthesisdataset[short_varname == "amoA_AOB", value := round(value, 3)]
synthesisdataset[short_varname == "16S_NB", value := round(value, 3)]


synthesisdataset[, value := as.character(value)]
synthesisdataset <- data.table(dcast(synthesisdataset, Plot + Plotn + Explo + Year ~ short_varname, fill = "NM"))
# NM = not measured --> distinguishes function-year combinations which were not measured from
#   actual NA values in existing (=measured) function-year combinations
#   is an artefact of the new format with the "year" column.
# sort columns exactly as in metadata
ordered_synthesisdataset <- synthesisdataset[, .(Plot, Plotn, Explo, Year, `16S_NB`, Aggregation, Biomass, 
                                                 Bulk_density, DEA, DEA_inverted, Groundwater_recharge,
                                                 Litter_decomposition, NH4, NO3, NRI, N_Acetyl_beta_Glucosaminidase, 
                                                 N_leaching_risk, NaHCO3_Pi, Nmic, Nshoot, OlsenPi, PRI, 
                                                 PRIcomb, P_leaching_risk, P_leaching_risk_comb, P_loss, 
                                                 Parasitoid_traps, Phosphatase, Pmic, Potential_nitrification, 
                                                 Pshoot, Root_biomass, Root_decomposition, Soil_depth, Soil_C_stock, 
                                                 Soil_C_concentration, SoilOrganicC, Total_pollinators, Urease, 
                                                 Xylosidase, amoA_AOA, amoA_AOB, beta_Glucosidase, 
                                                 caterpillars_predation, dung_removal, herbivory, mAMFhyphae, nifH, 
                                                 nxrA_NS, pathogen_infection, seed_depletion, soilAmmoniaflxs, 
                                                 soilCflxs, soilNitrateflxs)]
#TODO please not that 2 of the columns (soil_depth, Soil_C_concentration) could not be added to BExIS dataset yet, because
# data structure is fixed for a given data ID --> will be added for next versiion
ncol(ordered_synthesisdataset) == ncol(synthesisdataset)
names(synthesisdataset)[!names(synthesisdataset) %in% names(ordered_synthesisdataset)] # no column missed
synthesisdataset <- data.table::copy(ordered_synthesisdataset)
rm(ordered_synthesisdataset)

# final checks
nrow(unique(synthesisdataset)) == nrow(synthesisdataset) # no duplicates
length(unique(synthesisdataset$Year))
length(unique(synthesisdataset$Year))
nrow(synthesisdataset) == 150 * 13 # expected number of plots there

fwrite(synthesisdataset, file = "march2023_raw_functions_dataset_bexisformat_long.csv", dec = ".", sep = ",", quote = F, na = "NA")

# Dataset tuned for BExIS upload to 27087
synthesisdataset[, Soil_depth := NULL]
synthesisdataset[, Soil_C_concentration := NULL]
# dealing with artefact : there are values for year "4444.0", which was removed.
# No option to delete this year, therefore adding NA values in order to prevent people to use
# this fake year. 
# Note : assembled years are tagged with 444444.0, not with 4444.0
artefact_year <- synthesisdataset[Year == "444444", ]
artefact_year[, Year := 4444.0]
artefact_functions_cols <- names(artefact_year)[!names(artefact_year) %in% c("Plot", "Plotn", "Explo", "Year")]
artefact_year[, (artefact_functions_cols) := "NM"]
# add to synthesisdataset
synthesisdataset <- rbindlist(list(synthesisdataset, artefact_year))
nrow(synthesisdataset) == 14 * 150
fwrite(synthesisdataset, file = "27087_data_bexisformat.csv", dec = ".", sep = ",", quote = F, na = "NA")



# the below lines are generating upload helpers. Since the transition to Bexis2, the lines were not tested
# any more. They are left here to be tested for the next update.

####
# METADATA
#TODO : below here not updated.
# metadata <- fread("<path-to-synthesis-dataset>/synthesis_grassland_function_metadata_ID26726.csv", sep = ";")
# setnames(varkey, old = c("oldnames", "Year"), new = c("ColumnName", "codedYear"))
# metadata <- merge(varkey[, .(ColumnName, short_varname, codedYear)], metadata, by = "ColumnName")
# setnames(metadata, old = "short_varname", new = "ShortColumnName")
# fwrite(metadata, file = "synthesis_grassland_function_metadata_<ID>.csv", sep = ";")


####
# UPLOAD HELPER
# upload_helper <- unique(metadata[, .(ShortColumnName, typeOfVariable, units, `short description`)])
# upload_helper[, Block := 0]
# fwrite(upload_helper, file = "bexis_metadata_upload_helper.csv", sep = ";")
