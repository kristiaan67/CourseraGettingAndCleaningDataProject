library(dplyr)
library(data.table)
library(stringr)

## Download and unzip data set
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
              destfile = "UCI_HAR_Dataset.zip", method = "curl")
unzip("UCI_HAR_Dataset.zip")

# Load the common master data
# 1.1 load the activity labels
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", sep = " ", col.names = c("key", "activity"))

# 1.2 load the feature names
featureNames <- read.table("UCI HAR Dataset/features.txt", sep = " ", col.names = c("key", "feature"))

# 2. Load test data
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = c("subject"))
testLabels <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = c("key"))
testLabels <- merge(testLabels, activityLabels, by.x = "key", by.y = "key")
testSet <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = featureNames$feature)
testSet <- as_tibble(cbind(testSubjects, testLabels, testSet))

# 3. Load training data
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = c("subject"))
trainLabels <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = c("key"))
trainLabels <- merge(trainLabels, activityLabels, by.x = "key", by.y = "key")
trainSet <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = featureNames$feature)
trainSet <- as_tibble(cbind(trainSubjects, trainLabels, trainSet))

# merge the 2 data sets and select all the columns that have ".mean." or ".std." 
# in their name (+ "subject" and "activity")
fullSet <- rbind(testSet, trainSet)
tidySet <- select(fullSet, grep("subject|activity|\\.mean\\.|\\.std\\.", names(fullSet), value = TRUE)) %>%
    arrange("subject", "activity") %>% # sort by subject and activity
    rename_with(function(name) { # user friendly name of the variable
        str_replace_all(
            str_replace_all(
                str_replace_all(
                    str_replace_all(
                        str_replace_all(
                            str_replace_all(
                                str_replace_all(name, "Acc", "Acceleration"), 
                                "Mag", "Magnitude"), 
                            "\\.{2}", ""), 
                        "tBody", "Time.Body"), 
                    "fBody", "Freq.Body"), 
                "tGravity", "Time.Gravity"), 
            "fGravity", "Freq.Gravity")
    }) 
write.table(tidySet, file = "tidy_data.txt", row.name = FALSE, quote = FALSE) 

# melt the data by adding a column 'feature' with value the feature name
tidySet2 <- as_tibble(melt(as.data.table(tidySet), id.vars = c("subject", "activity"), variable.name = "feature"))
# compute the average by grouping by subject, activity and feature
avgValuesSet <- mutate(tidySet2, subject = as.factor(subject), activity = as.factor(activity)) %>% 
    group_by(subject, activity, feature) %>%
    summarize(average = mean(value))
print(avgValuesSet)
write.table(avgValuesSet, file = "average_data.txt", row.name = FALSE, quote = FALSE) 
