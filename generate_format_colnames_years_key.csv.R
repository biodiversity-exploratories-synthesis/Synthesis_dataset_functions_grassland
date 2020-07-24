#######################
#
# BExIS FORMAT
#
#######################
# To bring dataset into format required from BExIS and back, the table 
# "format_colnames_years_key.csv" is required. This script generates that table.
# Requires a dataset with old column names and the old metadata table.

# REQUIREMENTS
# - no "." (dot) character in column names
# - different years belong to different rows,not different columns
# - ---> but then we have a lot of empty cells...

require(data.table)

d <- fread("<dataset_with_old_colnames>")

##
# take away dot characters and replace with "_" character
varkey <- data.table(oldnames = colnames(d))
colnames(d) <- sub(".", "_", fixed = T, colnames(d))
colnames(d) <- sub(".", "_", fixed = T, colnames(d)) # second time for the names with 2 "." characteres
grep(".", fixed = T, colnames(d), value = T) # check if any dot is left

varkey[, variable := colnames(d)] # add to newnames


##
# Get Years
meta <- fread("<old-formatted-metadata-table.csv>")
setnames(meta, old = "ColumnName", new = "oldnames")
varkey <- merge(varkey, meta[, .(oldnames, Year)], by = "oldnames")
# NaHCO3_Pi was measured in years 2008 and 2009 --> give it 2008.5
# aggregated measures : 444444 (this number as it is spotted easily)
varkey[variable == "NaHCO3_Pi", Year := "2008.5"]
manually_inspectme <- varkey$Year[!varkey$Year %in% seq(2008, 2018, by = 0.5)]
varkey[Year %in% manually_inspectme, Year := "444444"]

# take away numbers from variable names
varkey[, short_varname := gsub("[0-9]{4}$", "", varkey$variable)] # remove 4 last numbers
varkey[, short_varname := gsub("[0-9]{4}$", "", varkey$short_varname)] # remove 4 last numbers
varkey[, short_varname := sub("_$", "", varkey$short_varname, perl = T)] # remove ending "_"

fwrite(varkey, file = "format_colnames_years_key.csv", quote = F, row.names = F)