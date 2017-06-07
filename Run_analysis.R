## You should create one R script called run_analysis.R that does the following.
##Merges the training and the test sets to create one data set.
##Extracts only the measurements on the mean and standard deviation for each measurement.
##Uses descriptive activity names to name the activities in the data set
##Appropriately labels the data set with descriptive variable names.
##From the data set in step 4, creates a second, 
##independent tidy data set with the average of each variable for each activity and each subject.

##Set home directory for Uzip and data reads

setwd("~/datascience/New folder (2)")
        unzip("getdata_projectfiles_UCI HAR Dataset.zip", files=NULL, 
              list = FALSE, overwrite = TRUE, 
              junkpaths =  FALSE, exdir = ".", 
              unzip = "internal", setTimes = FALSE)


## Read the test Data
        
test1 <- read.table("UCI HAR Dataset/test/X_test.txt")
test2 <- read.table("UCI HAR Dataset/test/Y_test.txt")
test3 <- read.table("UCI HAR Dataset/test/Subject_test.txt")
Supertest <- cbind(test1, test2, test3)

##Read the training Data

train1 <- read.table("UCI HAR Dataset/train/X_train.txt")
train2 <- read.table("UCI HAR Dataset/train/Y_train.txt")
train3 <- read.table("UCI HAR Dataset/train/Subject_train.txt")
Supertrain <- cbind(train1, train2, train3) 


library(stringr)
library(dplyr)
library(plyr)

##Read Feature List

feature <- sapply(strsplit(readLines('UCI HAR Dataset/features.txt'), " "), 
                  function(x) {x[2]})
feature <- gsub("-", "_", feature); 
feature <- gsub("\\(\\)", "", feature);

## Read the activity labels 

actlab <- sapply(strsplit(readLines('UCI HAR Dataset/activity_labels.txt'),
                          " "), function(x) {x[2]})

##Merge Data Sets

Xtt <- rbind(test1, train1)
Ytt <- rbind(test2, train2)
sbjdata <- rbind(test3, train3)

## Naming 

activities <- read.table("UCI HAR dataset/activity_labels.txt")

# update values with correct activity names
Ytt[, 1] <- activities[Ytt[, 1], 2]

# correct column name
names(Ytt) <- "activity"

names(sbjdata) <- "subject"

## Mean and Std Deviation

features <- read.table("UCI HAR Dataset/features.txt")

# obtain columns with mean() and std() on their names

mean_and_std <- grep("-(mean|std)\\(\\)", features[, 2])

# subset the desired columns 

meanstdXtt <- Xtt[, mean_and_std]

## correction on column names 

names(meanstdXtt) <- features[mean_and_std, 2] 

alldata <- cbind(meanstdXtt, Ytt, sbjdata)
averages_data <- ddply(alldata, .(subject, activity), function(x) colMeans(x[, 1:66])) 
write.table(averages_data, "averages_data.txt", row.name=FALSE)





