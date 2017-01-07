## README for Getting and Cleaning Data Course Project

This repository contains one R script, a codebook, and several text files that explain the variables and the underlying project that produced the original data sets.  The original data sets can be downloaded from the following link:  [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)


### <b>Run_Analysis.R</b> 
This file contains the R script to create a tidy data set.  After pulling the zip file and reading in the data sets, it procedes through the following steps:
  
* <b>1.</b> Merge the test and train set.
* <b>2.</b> Subset on the columns to only include mean and standard deviation measurements.
* <b>3.</b> Give the acitiviy variable descriptive values.
* <b>4.</b> Rename variable names to be descriptive.
* <b>5.</b> Create a tidy data set with the average of each variable, each activity, and each subject.

### <b>Codebook.md</b> 
This file contains details on the final tidy data set. 

### <b>Text Files</b> 
The following text files were included with the data sets in the zip folder.  They explain the original analysis and the variables used in the initial data sets. 

* <b>README.txt</b>: Documents the analysis that was performed </li>
* <b>features_info.txt</b>: Describes the measurements in more detail and the variables used </li>

