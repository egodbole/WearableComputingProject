# Created: 2020-04-19

# this code:
#      1. Merges the training and the test sets to create one data set.
#      2. Extracts only the measurements on the mean and standard deviation for
#           each measurement.
#      3. Uses descriptive activity names to name the activities in the data
#           set.
#      4. Appropriately labels the data set with descriptive variable names.
#      5. From the data set in step 4, creates a second, independent tidy data
#           set with the average of each variable for each activity and each
#           subject.

# loading packages
library(stringr)
library(dplyr)
library(data.table)

# downloading and unzipping data
#url <-
#"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#download.file(url, destfile="zipData.zip")

#unzip("zipData.zip")

# reading test data
#testData <- read.table(".\\UCI HAR Dataset\\test\\X_test.txt", sep="",
#                       header=FALSE)
#trainData <- read.table(".\\UCI HAR Dataset\\train\\X_train.txt", sep="",
#                       header=FALSE)
# merging the data
#     rows 1–2947: testData
#     rows 2948–10299: trainData
#totalData <- rbind(testData, trainData)

# feature names
names <- readLines(".\\UCI HAR Dataset\\features.txt")

#extracting mean and std dev columns
wantCols <- grepl("(mean|std)", names)

reqData <- totalData[, wantCols]

colnames(reqData) <- names[wantCols]

# getting activity and subjects
testAct <- readLines(".\\UCI HAR Dataset\\test\\y_test.txt")
testSub <- readLines(".\\UCI HAR Dataset\\test\\subject_test.txt")

trainAct <- readLines(".\\UCI HAR Dataset\\train\\y_train.txt")
trainSub <- readLines(".\\UCI HAR Dataset\\train\\subject_train.txt")

activities <- as.factor(c(testAct, trainAct))
levels(activities) <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS",
                        "SITTING", "STANDING", "LAYING")
subjects <- as.numeric(c(testSub, trainSub))

# adding activity and subject columns to data
reqData$activity <- activities
reqData$subject <- subjects

# renaming to more descriptive names
names(reqData) <- sub("t", "time", names(reqData))
names(reqData) <- sub("f", "freq", names(reqData))
names(reqData) <- sub("Acc", "Acceleration", names(reqData))
names(reqData) <- sub("Mag", "Magnitude", names(reqData))
names(reqData)[80:81] <- c("activity", "subject")

# melting and recasting data in the required format
meltData <- melt(reqData, id=c("activity", "subject"))
finalData <- dcast(meltData, activity + subject ~ variable, mean)