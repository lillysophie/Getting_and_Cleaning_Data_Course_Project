library(dplyr)
library(tidyr)
library(reshape2)

##1.Merging the training and test data set to create one data set.
activity_labels <- read.table("activity_labels.txt")
features <- read.table("features.txt")

path <- "~/R/Data Science Specialisation/Getting and Cleaning Data/UCI HAR Dataset"

#reads files from train data into R that are specified in path
read_train <- list.files(
  path = path,
  pattern = "(train).*txt$",
  recursive = TRUE
)
read_train
#extract subject, y(label) and X(set) *.txt files from train
list_train <- lapply(read_train[c(10,12, 11)], read.table)
#rename columns in dataframes
colnames(list_train[[1]]) <- "subject_ID"
colnames(list_train[[2]]) <- "activity"
colnames(list_train[[3]]) <- t(features[2])
#merge list into dataframe using bind_cols
df_train <- bind_cols(list_train)

##repeat for test data
#reads files from test data into R that are specified in path
read_test <- list.files(
  path = path,
  pattern = "(test).*txt$",
  recursive = TRUE
)
#extract subject, X and y *.txt files from test
list_test <- lapply(read_test[c(10,12,11)], read.table)
#rename columns in dataframes
colnames(list_test[[1]]) <- "subject_ID"
colnames(list_test[[2]]) <- "activity"
colnames(list_test[[3]]) <- t(features[2])
#merge list into dataframe using bind_cols
df_test <- bind_cols(list_train)

#bind rows of both dataframes together
df_dataset <- bind_rows(df_train, df_test)

##2.Extracting only measurements on the mean and standard deviation 
    #for each measurement.
#extract columns that include mean or std 
extract <- grep(".*mean.*|.*std.*", names(df_dataset), ignore.case = TRUE)
#add id and activity column
extracted_data <- select(df_dataset, subject_ID, activity, all_of(extract))
dim(extracted_data)

##3.Using descriptive activity names to name the activities in the data set.
extracted_data$activity <- recode(extracted_data$activity, 
                                  "1" = "WALKING", 
                                  "2" = "WALKING_UPSTAIRS",
                                  "3" = "WALKING_DOWNSTAIRS",
                                  "4" = "SITTING",
                                  "5" = "STANDING",
                                  "6" = "LAYING")

##4.Appropriately label the data set with descriptive variable names.
#Acc to Accelerometer
names(extracted_data) <- gsub("Acc", "Accelerometer", names(extracted_data))
#Gyro to Gyroscope
names(extracted_data) <- gsub("Gyro", "Gyroscope", names(extracted_data))
#arCoeff to arCoefficients
names(extracted_data) <- gsub("arCoeff", "arCoefficients", names(extracted_data))
#Mag to Magnitude
names(extracted_data) <- gsub("Mag", "Magnitude", names(extracted_data))
#f to frequency
names(extracted_data) <- gsub("^f", "frequency", names(extracted_data))
#t to time
names(extracted_data) <- gsub("^t", "time", names(extracted_data))
#BodyBody to Body
names(extracted_data) <- gsub("BodyBody", "Body", names(extracted_data))
#angle to Angle 
names(extracted_data) <- gsub("angle", "Angle", names(extracted_data))
write.table(extracted_data, file = "extracted.txt", row.names = FALSE)
##5.Creating a second, independent tidy data set with the average 
    #of each variable for each activity and each subject.
#subject = subject_ID
extracted_data$subject_ID <- as.factor(extracted_data$subject_ID)
tidy_data <- dcast(extracted_data, subject_ID + activity ~ . , mean)
write.table(tidy_data, file = "tidy.txt", row.names = FALSE)
