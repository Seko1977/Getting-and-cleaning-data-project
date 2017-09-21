###########################################################################
#Course 3 Getting and Cleaning Data Week 4 Project Assignment
############################################################################

###Requirements:
# 1.Merges the training and the test sets to create one data set.
# 2.Extracts only the measurements on the mean and standard deviation for each measurement.
# 3.Uses descriptive activity names to name the activities in the data set
# 4.Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with 
## the average of each variable for each activity and each subject.


##########################################################################
# Setting working directory and downloading the data
#########################################################################

# get and set the working directory
getwd()
setwd("./whichever directory specified")

# getting necessary packages
library(RCurl)
library(dplyr)

# download the file an place it into the folder
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="libcurl")

# unzip the file
unzip(zipfile="./data/Dataset.zip", exdir="./data")

# Put the unzipped files in the folder and get the list of files
path_rf <- file.path("./data" , "UCI HAR Dataset")
list.files("./data/UCI HAR Dataset", recursive=TRUE)


#########################################################################
# Reading the data
#########################################################################

# reading the training data sets
subject_train <- read.table(file.path(path_rf, "train", "subject_train.txt"))
x_train <- read.table(file.path(path_rf, "train", "X_train.txt"))
y_train <- read.table(file.path(path_rf, "train", "y_train.txt"))

# reading the testing data sets
subject_test <- read.table(file.path(path_rf, "test", "subject_test.txt"))
x_test <- read.table(file.path(path_rf, "test", "X_test.txt"))
y_test <- read.table(file.path(path_rf, "test", "y_test.txt"))

# reading features, don't convert text labels to factors
features <- read.table(file.path(path_rf, "features.txt"), as.is = TRUE)
head(features) ## to see the nature of the data

# read activity labels
activities <- read.table(file.path(path_rf, "activity_labels.txt"))
##colnames(activities) <- c("activityId", "activityLabel")


# naming columns 
colnames(subject_train) <- "subjectId"
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"

colnames(subject_test) <- "subjectId"
colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"

colnames(activities) <- c('activityId','activityType')


##########################################################################
# Step 1-  Merging the training and the test sets to create one data set
###########################################################################

mrg_train <- cbind(y_train, subject_train, x_train )
mrg_test <- cbind(y_test, subject_test, x_test)
setAllinOne <- rbind(mrg_train, mrg_test)


##############################################################################
# Step 2 - Extracting only the measurements on the mean and standard deviation
#          for each measurement
##############################################################################

# determine columns of data set to keep based on column name...
columnsToKeep <- grepl("subject|activity|mean|std", colnames(setAllinOne))


# ... and keep data in these columns only
setAllinOne <- setAllinOne[, columnsToKeep]

##############################################################################
# Step 3 - Using descriptive activity names to name the activities in the data
#          set
##############################################################################

# replace activity values with named factor levels
setAllinOne$activityId <- factor(setAllinOne$activityId, 
                                 levels = activities[, 1], labels = activities[, 2])


##############################################################################
# Step 4 - Appropriately labeling the data set with descriptive variable names
##############################################################################
# get column names
setAllinOneCols <- colnames(setAllinOne)
head(setAllinOne) # to view the data

# remove special characters
setAllinOneCols <- gsub("[\\(\\)-]", "", setAllinOneCols)
setAllinOneCols
# expand abbreviations and clean up names
setAllinOneCols <- gsub("^f", "frequencyDomain", setAllinOneCols)
setAllinOneCols <- gsub("^t", "timeDomain", setAllinOneCols)
setAllinOneCols <- gsub("Acc", "Accelerometer", setAllinOneCols)
setAllinOneCols <- gsub("Gyro", "Gyroscope", setAllinOneCols)
setAllinOneCols <- gsub("Mag", "Magnitude", setAllinOneCols)
setAllinOneCols <- gsub("Freq", "Frequency", setAllinOneCols)
setAllinOneCols <- gsub("mean", "Mean", setAllinOneCols)
setAllinOneCols <- gsub("std", "StandardDeviation", setAllinOneCols)

# correct typo
setAllinOneCols <- gsub("BodyBody", "Body", setAllinOneCols)

# use new labels as column names
colnames(setAllinOne) <- setAllinOneCols

##############################################################################
# Step 5 - Create a second, independent tidy set with the average of each
#          variable for each activity and each subject
##############################################################################

# group by subject and activity and summarise using mean
setAllinOneMeans <- setAllinOne %>% 
    group_by(subjectId, activityId) %>%
    summarise_all(funs(mean))

# output to file "tidy_data.txt"
write.table(setAllinOneMeans, "./data/tidy_data.txt", row.names = FALSE, 
            quote = FALSE)
