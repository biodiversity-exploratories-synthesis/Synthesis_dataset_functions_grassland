# script created by noelle schenk (noelle.schenk@unibe.ch), 13.01.2023

# # # # # # # # #
#
# CREATE .BIB FILE FROM SELECTED COLUMNS
#
# # # # # # # # #

# Aim : You are using the synthesis dataset 27087. You probably did not use all columns for your publication
#    (this is not recommended). In order to cite the source datasets of the columns you used, you can use this
#    script to generate a personal .bib file, which only contains the citations of the source datasets which
#    underlie the columns you have selected for your publication.

pathtodata <- "" # ACTION please fill here the path to the downloaded dataset

dataset <- read.delim("synthesis_grassland_function_metadata_ID27087.csv", sep = ";")

# ACTION : please fill the names of the columns (AggregatedColumnName) from 27087 that you have used.
selected_columns <- c("Pshoot.2014", "Biomass", "soilCflxs", "soilAmmoniaflxs", "soilCflxs")
selected_columns_citations <- dataset[which(dataset$AggregatedColumnName %in% selected_columns), "CitationString"]
write(paste(unique(selected_columns_citations), collapse = "\n"), "your_personal_bib_for_27087.bib")
# Note : the .bib file is generated in your current working directory, getwd()
# the generated .bib file can be imported to any citation manager, here it was tested with Zotero.
#    (Right click the .bib file, chose "Open with" and chose "Zotero" from the list)

# ACTION : please check for the citation of 27087 : which version of 27087 are you using?
#    if the version mentioned in the citation is not the one you used, please adapt by hand in the .bib file
#    note : you can do this manually in the .bib file with your Text manager, or manually within your 
#           citation manager. In case you do with citation manager : don't forget to re-edit every time you 
#           re-import the .bib file.
