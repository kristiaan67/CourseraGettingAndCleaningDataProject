# Getting and Cleaning Data Course Project

## Intro

This project contains one R script named 'run_analysis.R' that will download the 
[Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones), 
containing the recordings of 30 subjects performing activities of daily living (ADL) 
while carrying a waist-mounted smartphone with embedded inertial sensors.

The data set is then cleaned and a new data set is created containing the average of 
every variable that is a mean or standard deviation calculation of a measurement. 

The code book 'CodeBook.Rmd' describes the variables and calculations of the resulting data set.

## Usage

The R script can be executed by sourcing the file:

```{r eval=FALSE}
source('./run_analysis.R')
```

It takes no arguments and needs no configuration.

The R script will:

1. Download the data set from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
and unzip the content to the current working directory.

2. Load some common data to the training and test sets, i.e. the activity labels ('activity_labels.txt') 
and the feature names ('features.txt').

3. Load the test data set files ('subject_test.txt', 'y_test.txt', 'X_test.txt')
and merge them into one data frame.

4. Load the training data set files ('subject_train.txt', 'y_train.txt', 'X_train.txt')
and merge them into one data frame.

5. Merge the test and training data frames, thereby selecting only the columns that
contain an average or standard deviation calculation.

6. Rename these column names to a more friendly name and write out the resulting data frame ('tidy_data.txt').

7. To compute the average of each variable of the tidy data frame for each activity and subject, 
a new data frame is created by melting the tidy data (all columns except for 'subject' and 'activity').
The result is a data frame with 4 columns 'subject', 'activity', 'feature', 'value' with 'feature' being
the name of the column in the tidy data set and 'value' its measurement:

       subject activity feature                      value
         <int> <chr>    <fct>                        <dbl>
    1       2 WALKING  Time.BodyAcceleration.mean.X 0.257
    2       2 WALKING  Time.BodyAcceleration.mean.X 0.286
    3       2 WALKING  Time.BodyAcceleration.mean.X 0.275
    ...

8. Finally this data set is aggregated by calculating the mean of the measurements 
grouped by 'subject', 'activity' and 'feature' and the resulting data frame is 
written to the file 'average_data.txt'.

### Output

The script generates the following output (i.e. files and directories):

1. File 'UCI_HAR_Dataset.zip' and directory 'UCI HAR Dataset': the downloaded data set.
2. File 'tidy_data.txt': the tidy data set.
3. File 'average_data.txt': the final data set with the average measurement values

These files can be deleted since they will be generated every time the R script is ran.
