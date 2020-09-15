#######################
#
# BExIS FORMAT
#
#######################
require(data.table)

varkey <- fread("format_colnames_years_key.csv")
synthesisdataset <- fread("<path-to-synthesis-dataset>/june2020_raw_functions_dataset.csv")

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
# NM = not measured
setorder(synthesisdataset, Plotn, Explo)
#TODO solve the encoding problem for Bexis upload
# synthesisdataset <- fread("~/Documents/IPS_2020/dataset_upload/june2020_raw_functions_dataset_bexisformat_long.csv")
# # sort columns alphabetically
# test[ , order(names(test))]
# on <- names(synthesisdataset)[order(names(synthesisdataset))]
# synthesisdataset <- synthesisdataset[, ..on]
fwrite(synthesisdataset, file = "june2020_raw_functions_dataset_bexisformat_long.csv", dec = ".", sep = ",", quote = F)

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
