Getting and Cleaning Data Course Project

The R script run_analysis.R does the following 

1. Downloading the dataset into the current working directory if doesn't exists 
2. Unzip the files
3. Read activity, subject & feature files (both train and test data)
4.Join Train and Test table and the new table is "dataFeatures"
5. Getting features names from "features.txt" file 
6. Renaming v1, v2 etc., to their respective elaborate names (changes saved in "dataFeatures")
7. Loads both the training and test datasets, keeping only those columns which reflect a mean or standard deviation (table "subsetdata")
8. Loads descriptive activity names to name the activities in the data set.(table "finaldata")
9.creates a second, independent tidy data set with the average of each variable for each activity and each subject (df "tidy")
10.The end result is shown in the file tidy.csv
 


