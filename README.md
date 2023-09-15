# Getting-and-Cleaning-Data Week 4 Assignment
This repository is my submission for the Week 4 Assignment. The files are embedded in the code to download. 

# Datasets
This data is derived from the UC Irvine Machine Learning Repository collected from the Samsung Galaxy S smartphone accelerometers. It contains multiple measures from 30 participants between 19-48 years. Each participant performed six activities (walking, walking upstairs, walking downstairs, sitting, standing, and laying down) while wearing the smartphone. 

# run_analysis.R File
This code cleans and reorganizes the UC Irvine data by calling all the datasets, merging the datasets within one another, filtering out specific variables, renames the columns, and creates factors. This code uses the dplyr package heavily.

# Tidy Dataset
This .txt file contains the UC Irvine data that filters in only the mean and standard deviation data for each pariticipant's each six activities. It groups the data and finds the mean of each group for each subset.
