#######################
#
# BExIS FORMAT
#
#######################
require(data.table)

varkey <- fread("format_colnames_years_key.csv")
# synthesisdataset <- fread("<path-to-synthesis-dataset>/june2020_raw_functions_dataset.csv")

# convert numeric column to numeric
num <- colnames(synthesisdataset)[!colnames(synthesisdataset) %in% c("Plot", "Plotn", "Explo")]
synthesisdataset[, (num) := lapply(.SD, as.numeric), .SDcols = num]
rm(num)

synthesisdataset <- data.table(melt(synthesisdataset, id = c("Plot", "Plotn", "Explo")))
setnames(synthesisdataset, old = "variable", new = "oldnames")

synthesisdataset <- merge(synthesisdataset, varkey[, .(oldnames, short_varname, Year)], by = "oldnames")
synthesisdataset[, oldnames := NULL]
synthesisdataset[, value := as.character(value)]
synthesisdataset <- dcast(synthesisdataset, Plot + Plotn + Explo + Year ~ short_varname, fill = "NM")
# NM = not measured --> distinguishes function-year combinations which were not measured from
#   actual NA values in existing (=measured) function-year combinations
#   is an artefact of the new format with the "year" column.
# sort columns exactly as in metadata
ordered_synthesisdataset <- synthesisdataset[, .(Plot, Plotn, Explo, Year, `16S_NB`, Aggregation, Biomass, Bulk_density, DEA, DEA_inverted, Groundwater_recharge, Litter_decomposition, NH4, NO3, NRI, N_Acetyl_beta_Glucosaminidase, N_leaching_risk, NaHCO3_Pi, Nmic, Nshoot, OlsenPi, PRI, PRIcomb, P_leaching_risk, P_leaching_risk_comb, P_loss, Parasitoid_traps, Phosphatase, Pmic, Potential_nitrification, Pshoot, Root_biomass, Root_decomposition, Soil_C_stock, SoilOrganicC, Total_pollinators, Urease, Xylosidase, amoA_AOA, amoA_AOB, beta_Glucosidase, caterpillars_predation, dung_removal, herbivory, mAMFhyphae, nifH, nxrA_NS, pathogen_infection, seed_depletion, soilAmmoniaflxs, soilCflxs, soilNitrateflxs)]
names(synthesisdataset)[!names(synthesisdataset) %in% names(ordered_synthesisdataset)] # no column missed
synthesisdataset <- copy(ordered_synthesisdataset)
rm(ordered_synthesisdataset)
fwrite(synthesisdataset, file = "june2020_raw_functions_dataset_bexisformat_long.csv", dec = ".", sep = ",", quote = F, na = "NA")

####
# METADATA
metadata <- fread("<path-to-synthesis-dataset>/synthesis_grassland_function_metadata_ID26726.csv", sep = ";")
setnames(varkey, old = c("oldnames", "Year"), new = c("ColumnName", "codedYear"))
metadata <- merge(varkey[, .(ColumnName, short_varname, codedYear)], metadata, by = "ColumnName")
setnames(metadata, old = "short_varname", new = "ShortColumnName")
fwrite(metadata, file = "synthesis_grassland_function_metadata_<ID>.csv", sep = ";")


####
# UPLOAD HELPER
upload_helper <- unique(metadata[, .(ShortColumnName, typeOfVariable, units, `short description`)])
upload_helper[, Block := 0]
fwrite(upload_helper, file = "bexis_metadata_upload_helper.csv", sep = ";")
