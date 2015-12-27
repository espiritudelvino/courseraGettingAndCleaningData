##########################################################################
# Create one R script called run_analysis.R that does the following.

# install plyr if not found
if (!require("plyr")) {
    install.packages("plyr")
}
library(plyr)

##########################################################################
# 1. Merges the training and the test sets to create one data set.

# training
xTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
yTrain <- read.table("UCI HAR Dataset/train/y_train.txt")
sTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")

# test
xTest <- read.table("UCI HAR Dataset/test/X_test.txt")
yTest <- read.table("UCI HAR Dataset/test/y_test.txt")
sTest <- read.table("UCI HAR Dataset/test/subject_test.txt")

# merge
x <- rbind(xTrain, xTest)
y <- rbind(yTrain, yTest)
s <- rbind(sTrain, sTest)

##########################################################################
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

features <- read.table("UCI HAR Dataset/features.txt")

meanOrStdev <- grep("-(mean|std)\\(\\)", features[, 2])
x <- x[, meanOrStdev]
names(x) <- features[meanOrStdev, 2]

##########################################################################
# 3. Uses descriptive activity names to name the activities in the data set

activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
#print(head(activityLabels))
y[, 1] <- activityLabels[y[, 1], 2]

##########################################################################
# 4. Appropriately labels the data set with descriptive variable names. 

#print(head(s))
#print(head(y))
names(s) <- "Subject"
names(y) <- "Activity"
data <- cbind(x, y, s)

##########################################################################
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

avg <- ddply(data, .(Subject, Activity), .fun=function(x){ colMeans(x[, 1:66]) })
# data set as a txt file created with write.table() using row.name=FALSE
write.table(avg, "tidyAvg.csv", row.name=FALSE)