# # # # # # # # # # # # # #
#                         #
# create 27087_helper.csv #
#                         #
# # # # # # # # # # # # # #
#
# Creation : file created 23.03.2023 by noelle. Last edit : 23.03.2023 by noelle
# Aim : create the helper dataset "27087_helper.csv" which simply is a subset 
#    of the attached metadata file "synthesis_grassland_function_metadata_ID27087.csv".
#    which is attached to the BExIS dataset 27087

# Requirements
library(data.table)

# Read input file
# the input file is the attached metadata table of 27087 "synthesis_grassland_function_metadata_ID27087.csv".
# Please download this metadata table and point to it using the below path :
#USER : insert path to "synthesis_grassland_function_metadata_ID27087.csv"
grlfun_metadata <- fread("/run/user/1000/gvfs/smb-share:server=nas-ips,share=ips/groups/planteco/PROJECTS/Exploratories Synthesis/Data/Grassland_functions/27087_grassland_functions_bexis/27087_25_Dataset/synthesis_grassland_function_metadata_ID27087.csv")

# select the necessary columns and save output to working directory
#    note : save to working directory, because 27087_helper.csv is stored in the same directory as the code.
info_data <- grlfun_metadata[, .(ColumnName, AggregatedColumnName, codedYear, purpose, noPlots, dataID, subpath_unix, Projectname)]
fwrite(info_data, file = "27087_helper.csv", sep = ";")

rm(info_data, grlfun_metadata)
gc()
