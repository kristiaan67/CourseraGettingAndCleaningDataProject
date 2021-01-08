library(dplyr)
library(data.table)
library(stringr)

## 1. Download and unzip data set
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
              destfile = "UCI_HAR_Dataset.zip", method = "curl", quiet = TRUE)
unzip("UCI_HAR_Dataset.zip")

## 2. Load the common master data
## 2.1 load the activity labels
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", sep = " ", col.names = c("key", "activity"))

## 2.2 load the feature names
featureNames <- read.table("UCI HAR Dataset/features.txt", sep = " ", col.names = c("key", "feature"))

## 3. Load test data
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = c("subject"))
testLabels <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = c("key"))
testLabels <- merge(testLabels, activityLabels, by.x = "key", by.y = "key")
testSet <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = featureNames$feature)
testSet <- as_tibble(cbind(testSubjects, testLabels, testSet))

## 4. Load training data
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = c("subject"))
trainLabels <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = c("key"))
trainLabels <- merge(trainLabels, activityLabels, by.x = "key", by.y = "key")
trainSet <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = featureNames$feature)
trainSet <- as_tibble(cbind(trainSubjects, trainLabels, trainSet))

## 5. Merge the 2 data sets
fullSet <- rbind(testSet, trainSet)
# 5.1 select only the columns that have ".mean." or ".std." in their name (+ "subject" and "activity")
tidySet <- select(fullSet, grep("subject|activity|\\.mean\\.|\\.std\\.", names(fullSet), value = TRUE)) %>%
    arrange("subject", "activity") %>% # sort by subject and activity
# 5.2 rename those columns
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
# 5.3 write out the tidy data set
write.table(tidySet, file = "tidy_data.txt", row.name = FALSE, quote = FALSE) 

## 6. Create a new data set with the average values of each feature
# 6.1 melt the data by adding a column 'feature' and the feature name as value
avgValuesSet <- as_tibble(melt(as.data.table(tidySet), id.vars = c("subject", "activity"), variable.name = "feature"))

# 6.2 compute the average by grouping by subject, activity and feature
avgValuesSet <- mutate(avgValuesSet, subject = as.factor(subject), activity = as.factor(activity)) %>% 
    group_by(subject, activity, feature) %>%
    summarize(average = mean(value))
print(avgValuesSet)
# 6.3 write out the new data set
write.table(avgValuesSet, file = "average_data.txt", row.name = FALSE, quote = FALSE) 

print("Done.")
