# Getting-and-cleaning-data-project

Getting and Cleaning Data Course Project
****************************************************

This repository contains the R code and documentation files for the Data Science's track course "Getting and Cleaning data", available in coursera. The relevant files are as follows:

1. README.md, this file, which provides an overview of the data set and how it was created.
2. tidy_data.txt, which contains the data set.
3. CodeBook.md, the code book, which describes the contents of the data set (data, variables and transformations used to generate the data).
4. run_analysis.R, the R script that was used to create the data set (see the Creating the data set section below)

Creating the data set
*****************************************************

The R script run_analysis.R aims to create the data set and tidy.txt file contains the outcome after runnung this script. The steps in the document are as follows:

Step 0A- Download and unzip source data if it doesn't exist.
Step 0B- Read data.
Step 1- Merge the training and the test sets to create one data set.
Step 2- Extract only the measurements on the mean and standard deviation for each measurement.
Step 3- Use descriptive activity names to name the activities in the data set.
Step 4-Appropriately label the data set with descriptive variable names.
Step 5- Create a second, independent tidy set with the average of each variable for each activity and each subject.
Step6- Write the data set to the tidy_data.txt file.

So, the tidy_data.txt is created by running the run_analysis.R script using R version 3.4.1 on Windows 8.1 64-bit edition.
