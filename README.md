# 2019_grassland_functions

Generation of the 2019 synthesis grassland function dataset.

Contains :
- 1read_raw_dataset.Rmd : to read in raw data. Start with this file, after you downloaded all required datasets from Bexis and unzipped them. It contains minor calculations, but mostly it contains code to clean and format the data for the next script.
- 2calc_raw_dataset.Rmd  : It takes the output from file 1, and calculates the functions from it. Finally, it saves the constructed functions dataset as a .csv file under a name of your choice. *Note*: that when running it, it asks the user (you) to write a name for the file, and the script does not stop running until you gave one (there is more description in the file itself).
- input_for_2calc.R : An R script which can be run before calculating mini-multifunctionalities. It checks the correlations between functions and performs a PCA.
- 3explore_functions_dataset : An example of how to explore missing data and correlations in the previously generated dataset.
- multidiversity.R : contains required function. Is sourced by the above file.

probably not useful :
- compare_raw_functoins_to_synthesis_dataset.Rmd : a file to compare columns to another, older dataset .
- clean_datasets.R : functions for the above script to compare the columns.
