## Codebook for Getting and Cleaning Data Course Project

The goal of the project was to create a tidy data set from a test and train set which can be dowloaded from here:  [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).  This file documents the variables in the tidy data set that is created from the Run_Analysis.R script.

For details on the raw data, refer to the following text files:  README.txt, features_info.txt

# <b>Tidy data set</b> 
The tidy data set displays the average mean and standard deviation across each variable, activity and subject.  Below are the column names, a brief description of the variables and their values.
  
* <b>Activity</b> Factor variable with 6 levels: Laying, Sitting, Standing, Walking, Walking_Downstairs, Walking_Upstairs
* <b>Subject</b> Integer variable with 30 values, 1:30, indicating which subject performed the task.
* <b>Domain</b> Character variable with 2 values: frequency, time. Distinguishes between time domain signals and frequency domain signals.  Frequency domain signals were the result of performing a fast fourier transform on the time domain signal.
* <b>Measurement</b> Character variable with 5 values: BodyAcceleration, BodyAccelerationJerk, BodyGyroscope, BodyGyroscopeJerk, GravityAcceleration. This variable distinguishes what filtering process the domain signal went through.  For more details, see the features_info.txt file.
* <b>Direction</b> Character variable with 4 values: x, y, z, Magnitude. For each measurement, 4 values were captured indicating the direction of the signal, or the magnitude of the signal.
* <b>Average_Mean</b> Numeric variable, the result of averaging the mean across each variable, for each subject and each activity. 
* <b>Average_StDev</b> Numeric variable, the result of averaging the standard deviation across each variable, for each subject and each activity.
