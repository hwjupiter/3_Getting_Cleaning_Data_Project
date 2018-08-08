
The R script run_analysis.R performs data manipulation on a given dataset, which contains
information regarding the physical activities performed by various individuals. The script
performs the following when run:

1. If the dataset does not exist, it will be downloaded and unzipped.
2. The training data is read in and combined into a single table (it is initially in three
   separate tables).
3. The testing data is read in and combined into a single table (it is initially in three
   separate tables).
4. The data about the specific activities performed is read into a single table.
5. The data about the features that were recorded during each activity is read into a single
   table.
6. The training and testing data are mergind into a single table.
7. As only the features related to mean and standard deviation are of interest in this 
   particular case, the columns from the new combined data are extracted.
8. The activities performed were originally descripbed by numbers. These numbers are replaced
   with more accurate descriptions, taken from the activities data read in previously.
9. Any abbreviations used in the descriptions of the recorded features are then replaced 
   with complete descriptions.
10. The mean values of the features recorded across subjects and activities are calculated,
    and a new tidy dataset is created from this data.
11. The new tidy dataset is then written to a text file, namely new_tidy_data.txt.

Software versions:
	Windows 10 x86 64-bit
	R version 3.5.0 (2018-04-23)
	RStudio version 1.1.453

Specific R libraries used:
	dplyr (loaded when script is run)