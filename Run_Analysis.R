########### Getting and Cleaning Data Course Project  #################
## 12.30.2016
## The script below will download zip folder containing the data
## Combine data sets, clean variable names, and transform into tidy data
## The final table will have some summary statistics
## The project had steps 1:5 which can be found below as ## n ##
#######################################################################

library(dplyr)
library(tidyr)

## 0.1 ## 
## Download files, unzip folder.  Skip if already exist.

if(!file.exists("Week4 Project"))
    { 
    dir.create("Week4 Project")
    url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(url, "./Week4 Project/UCI HAR Dataset.zip")
    unzip("./Week4 Project/UCI HAR Dataset.zip",exdir = "./Week4 Project")
}

## 0.2 ##
setwd("./Week4 Project/UCI HAR Dataset")

###### Info From Readme doc   ##############
#  'train/X_train.txt': Training set  
#  'train/y_train.txt': Training labels
#  'test/X_test.txt': Test set        
#  'test/y_test.txt': Test labels
#  'features_info.txt': Shows information about the variables used on the feature vector.
#  'features.txt': List of all features.
#  'activity_labels.txt': Links the class labels with their activity name.
#  'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. 
#       Its range is from 1 to 30.
###########################################


## 1 ## 
## Merge train set and test set. Assign appropriate labels.

## 1.1 ## 
## read in the data

## Train/Test Set is the data set of values for the training/testing set
## Train/Test Labels identifies the activity for each observation in values 1:6
## train/test _id identifies which subject performed the activity for each observation (row)
TrainSet <- read.table("./train/x_train.txt")
TrainLabels <- read.table("./train/y_train.txt")
train_id <- read.table("train/subject_train.txt")
TestSet <- read.table("./test/x_test.txt")
TestLabels <- read.table("./test/y_test.txt")
test_id <- read.table("test/subject_test.txt")

## features provides the column names for the data sets
## Activity match map 1:6 to the activity~ walking, walking upstairs etc.
features <- read.table("features.txt")
Activity_Match <- read.table("activity_labels.txt")


## 1.2 ## 
##  do some data checks
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX#
# head(TrainSet[,1:10])
# all(colSums(is.na(TrainSet))==0)  #returns TRUE
# all(colSums(is.na(TestSet))==0)  #returns TRUE
# table(TrainLabels)
# TrainSet[1:20,1:10]
# head(features,25)
# Activity_Match

# mean_col <- grep("mean()", features$V2)
# features$V2[mean_col]
# std_col <- grep("std()", features$V2)
# features$V2[std_col]
# meanFreq_col <- grep("meanFreq", features$V2)
# mean_col_clean <- grep(("mean[^Freq]"), features$V2)
# set_columns <- grep("std|mean[^Freq]", features$V2)
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX#

## 1.3 ##
##  start combining data sets/labels

##  Add activity to train/test sets, assigning descriptive names
TrainLabels <- merge(TrainLabels,Activity_Match, by = "V1")
TestLabels <- merge(TestLabels,Activity_Match, by = "V1")
TrainSet$Activity <- TrainLabels$V2
TestSet$Activity <- TestLabels$V2
##  Add subject id column to train/test set
##  Note: train_id and test_id are "lists" which was causing an error in rbind
##        however, they are just vectors of integer values, which is what they 
##        become after using "unlist"
TrainSet$Subject <- unlist(train_id)
TestSet$Subject <- unlist(test_id)
##  Add columns to identify which set the data came from
TrainSet$Set <- "Train"
TestSet$Set <- "Test"
row.names(TrainSet) <- NULL
row.names(TestSet) <- NULL

## 1.4 ##
##  Merge data sets into one data set
Data <- rbind(TrainSet, TestSet)
##  Add column headers and index (index used for sorting later)
Data$index <- 1:nrow(Data)
names(Data)[1:length(features$V2)] <- c(as.character(features$V2))

View(Data)

## remove large tables
rm(TrainSet)
rm(TestSet)

## 2 ##
## Select only the columns with standard deviation and mean
## Plus the identifying columns: Activity, subject, set, index

## columns with standard deviation and mean (excluding mean frequency)
set_columns <- grep("std|mean[^Freq]", features$V2)
Data <- Data[, c(set_columns,562:565)]

View(Data)

## 3 ##
## Use descriptive activity names to name the activities in the data set
## Note: this was done above in step 1.3
## To view print to console: table(Data$Activity)

## 4 ##
## Appropriately label the data set with descriptive variable names
names(Data) <- gsub("BodyBody", "Body", names(Data))
names(Data) <- gsub("\\(\\)", "", names(Data))
names(Data) <- gsub("std", "StandardDeviation", names(Data))
names(Data) <- gsub("Gyro", "Gyroscope", names(Data))
names(Data) <- gsub("Mag-mean", "-Mean-Magnitude", names(Data))
names(Data) <- gsub("Mag-StandardDeviation", "-StandardDeviation-Magnitude", names(Data))
names(Data) <- gsub("mean", "Mean", names(Data))
names(Data) <- gsub("Mag-StandardDeviation-", "-StandardDeviation-Magnitude", names(Data))
names(Data) <- gsub("Acc", "Acceleration", names(Data))
names(Data) <- gsub("tBody", "time-Body", names(Data))
names(Data) <- gsub("fBody", "frequency-Body", names(Data))
names(Data) <- gsub("tGrav", "time-Grav", names(Data))

## Note: the labels are now descriptive.
##  I chose to keep CAPS in some cases to help distinguish names
##  At this stage this is not a tidy dataset so there are multiple variables in columns
##  I included dashes "-" to distinguish the variables that will be separated in Part 5
names(Data)

## 5 ##
## From the data set in step 4, create a second, independent tidy data set
## with the average of each variable for each activity and each subject

## 5.1 ##
## Create a tidy data set
## Will pipe on Data to separate and rearrange variables
## WIth the goal to give each descriptive variable one column


Data <- Data %>%
            gather(key, Value, -(67:70)) %>%
            separate(key, c("Domain", "Measurement", "StdMean", "Direction"), sep = "-") %>%
            spread(StdMean, Value)

## Data is now "tidy data"
View(Data)

## 5.2 ##
##  Create summary data, averaging mean and standard deviation over "all variables"
##  Activity, Subject, Domain, Measurement, Direction

Data_summary <- Data %>%
                    group_by(Activity, Subject, Domain, Measurement, Direction) %>%
                    summarize(Average_Mean = mean(Mean), Average_StDev = mean(StandardDeviation)) %>%
                    arrange(Subject, Activity, Domain, Measurement, Direction)

View(Data_summary)


setwd("..")
write.table(Data_summary,"tidydata.txt", row.names = FALSE)

