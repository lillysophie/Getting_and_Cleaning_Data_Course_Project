### Getting and Cleaning Data Course Project

The data for this analysis can be obtained through the link:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 


## Aim of this Project was to create one R script called run_analysis.R that does the following:

   1. Merges the training and the test sets to create one data set.
   2. Extracts only the measurements on the mean and standard deviation for each  measurement. 
   3. Uses descriptive activity names to name the activities in the data set
   4. Appropriately labels the data set with descriptive variable names. 
   5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## This repository contains:

 - explanatory README file
 - CodeBook with explanation of the variables used in the analysis
 - run_analysis.R script that was used to perform the data cleaning
 - extracted.txt file with the data frame that was created from points 1.- 4.
 - tidy.txt file with the data frame that was created in point 5.

## Analysis file

The analysis requires some R.packages (dplyr, tidyr, reshape2) that need to be loaded into the library beforehand.

# 1. Merges the training and the test sets to create one data set.

Reading the activity_labels and features .txt files into R.
Defining the path in which the UCI HAR Dataset is stored.
Listing all files in path that contain train within their name. Followed by reading in the files for subject, y_train, and X_train into R and chaning the column names according to subject_ID, activity_levels and features.
Creating a data frame that binds the columns of the list that was created out of the three .txt files.

This was repeated exactly for the test files.

Then both data frames (df_train and df_test) were bound using the bind_rows command.

## 2. Extracts only the measurements on the mean and standard deviation for each  measurement.

From the combined data frame (df_dataset) the columns were extracted that included either *mean* or *std* in their name using the grep command. As a result, the columns were selected and a new dataframe (extracted_data) was created including subject_ID and activity.

## 3. Uses descriptive activity names to name the activities in the data set

The numbers that were used as indicator for the activity levels were changed to the descriptive activity found in the activity_labels .txt file.

## 4. Appropriately labels the data set with descriptive variable names.

Looking at the features .txt file it was decided which variable names to change appropriately. These were then changed to the desired ones using the gsub function.
The following function was to store the created data table into a .txt format.

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Finally, the subject_ID variable was changed to a factor variable to be able to perform the following analysis. 
In order to look at the average measurement of each combination of subject_ID and activity, the dcast function from the reshape2 package was used. 
The last expression was to store the created data table into a .txt format.
