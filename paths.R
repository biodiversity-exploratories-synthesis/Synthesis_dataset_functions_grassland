#########################
#
#  paths and INPUT
#
#########################
# for grassland ecosystem function dataset creation
# note : was called "nonpublic.R" before (will appear in documentation like this)

# Idea
# This document holds information about input paths and location of documents

# Dataset
# obtain dataset from BExIS
# alternative obtain locally (only if you have also applied on BExIS)
# data is stored in the planteco drive, at planteco/PROJECTS/Exploratories Synthesis/Data/Grassland_functions

# path to the folder where data is stored. Only if data is downloaded directly.
pathtodata <- "/run/user/1000/gvfs/smb-share:server=nas-ips,share=ips/groups/planteco/PROJECTS/Exploratories Synthesis/Data/Grassland_functions/for_developer/raw_data/"
# note : pathtodata and path-to_bexis_datasets point to same file. Could be an error, or could be that
#    the latter is not used at all. keeping both.
path_to_bexis_datasets <- "/run/user/1000/gvfs/smb-share:server=nas-ips,share=ips/groups/planteco/PROJECTS/Exploratories Synthesis/Data/Grassland_functions/for_developer/raw_data/"

# path to file which contains all data paths
#TODO potentially add path to where data from BExIS is stored. Note that this changes at every new version.
# e.g. in June 2023 at : 
info_data <- "/run/user/1000/gvfs/smb-share:server=nas-ips,share=ips/groups/planteco/PROJECTS/Exploratories Synthesis/Data/Grassland_functions/27087_grassland_functions_bexis/27087_24_Dataset/synthesis_grassland_function_metadata_ID27087.csv"

# old synthesis dataset
# refers to the dataset on BExIS before this one was built
# https://www.bexis.uni-jena.de/Data/ShowXml.aspx?DatasetId=21688
# marias dataset
# https://www.bexis.uni-jena.de/Data/ShowXml.aspx?DatasetId=24367
