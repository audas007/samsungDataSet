## Read data for test set
testX <- read.table("UCI HAR Dataset/test/X_test.txt")
testY <- read.table("UCI HAR Dataset/test/y_test.txt")
testSubject <- read.table("UCI HAR Dataset/test/subject_test.txt")

## Read data for training set
trainX <- read.table("UCI HAR Dataset/train/X_train.txt")
trainY <- read.table("UCI HAR Dataset/train/y_train.txt")
trainSubject <- read.table("UCI HAR Dataset/train/subject_train.txt")

## Bind the data for test set
## We use column bind here
totalTest <- cbind(testSubject, testX, testY)

## Bind the data for training set
## We use column bind here
totalTrain <- cbind(trainSubject, trainX, trainY)

## Bind the data for TRAINING + TEST set
## We use row bind here
totalData <- rbind(totalTest, totalTrain)

## Reading the activity labels
activity <- read.table("UCI HAR Dataset/activity_labels.txt")

## Renaming the columns to user-friendly names
colnames(activity) <- c("activityId", "activityName")

## Reading the column names from features.txt
features <- read.table("UCI HAR Dataset/features.txt")
## Getting the existing column names for given features
existingFeatureColNames <- features$V2

## Honoring the two new column names that we used in the cbind functions above
totalCols <-
    c("subjectId", as.character(existingFeatureColNames), "activityId")
colnames(totalData) <-
    make.names(totalCols, unique = TRUE, allow_ = TRUE)

## Cleaning up the colNames to remove unecessary DOTS, from the above step
colnames(totalData) <- gsub("\\.+", "\\.", colnames(totalData))

## Merging the data from two data frames, based on "activityId"
cleanTotalData <- merge(totalData, activity, by = "activityId")

## Make a list of column names that we want, namely std() and mean()
stdCols <-
    colnames(cleanTotalData)[grep("std\\.", colnames(cleanTotalData))]
meanCols <-
    colnames(cleanTotalData)[grep("mean\\.", colnames(cleanTotalData))]
validCols <- c("subjectId", stdCols, meanCols, "activityName")

## select only those columns from the "cleanTotalData" set
myData <- select(cleanTotalData, one_of(validCols))

## compute mean of data, grouped by "subjectId", then "activityName"
library(data.table)
DT <- data.table(myData)
result <- DT[, lapply(.SD, mean), by = c("subjectId", "activityName")]
colnames(result) <- gsub("\\.$", "", colnames(result))