library(plyr)
library(dplyr)
# Step1: Merges the training and the test sets to create one data set.

# read files into dataframe tables

setwd("D:/kenfile/personal/datascience/dataclean/week4-assignment")

fileSubject_train <- "./UCIHARDataset/train/subject_train.txt"
dataSubject_train <- read.table(fileSubject_train)

fileX_train <- "./UCIHARDataset/train/X_train.txt"
dataX_train <- read.table(fileX_train)
fileY_train <- "./UCIHARDataset/train/y_train.txt"
dataY_train <- read.table(fileY_train)

fileSubject_activityLabels <- "./UCIHARDataset/activity_labels.txt"
dataSubject_activityLabels <- read.table(fileSubject_activityLabels)

fileSubject_features <- "./UCIHARDataset/features.txt"
dataSubject_features <- read.table(fileSubject_features)

trainNames <- dataSubject_features[,2]

colnames(dataX_train) <- trainNames
colnames(dataY_train)[1] <- "Activity"
trainData <- cbind(dataX_train, dataY_train)
colnames(dataSubject_train) <- "Subject"
trainData <- cbind(trainData, dataSubject_train)


fileSubject_test <- "./UCIHARDataset/test/subject_test.txt"
dataSubject_test <- read.table(fileSubject_test)
fileX_test <- "./UCIHARDataset/test/X_test.txt"
dataX_test <- read.table(fileX_test)
fileY_test <- "./UCIHARDataset/test/y_test.txt"
dataY_test <- read.table(fileY_test)

colnames(dataX_test) <- trainNames
colnames(dataY_test)[1] <- "Activity"
testData <- cbind(dataX_test, dataY_test)
colnames(dataSubject_test) <- "Subject"
testData <- cbind(testData, dataSubject_test)
oneDataSet <- rbind(trainData, testData)

# Step2: Extracts only the measurements on the mean and standard deviation for each measurement.

colNameODS <- gsub(",","-", colnames(oneDataSet))
# make.names(names=names(master_merge), unique=TRUE, allow_ = TRUE)
make.names(names=names(oneDataSet), unique=TRUE, allow_ = TRUE)
colnames(oneDataSet) <- make.names(names=names(oneDataSet), unique=TRUE, allow_ = TRUE)

onlyDataSet <- select (oneDataSet, contains("mean"), contains("std"), contains("Activity"), contains("Subject") )


# Step3: Uses descriptive activity names to name the activities in the data set
# to find each activity ID inside onlyDataSet
onlyDataSet1 <- mutate(onlyDataSet, Activity = dataSubject_activityLabels[onlyDataSet[,"Activity"], 2])

# Step4: Appropriately labels the data set with descriptive variable names.
# already bind in line 27 to 28

# Step5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

resultData <- ddply(onlyDataSet1, .(Subject, Activity), function(x) colMeans(x[, 1:66]))

write.table(resultData, "result_data.txt", row.name=FALSE)
#