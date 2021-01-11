# Getting and Cleaning Data Course Project

## Intro

This project contains one R script named *run_analysis.R* that will download the 
[Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones), 
containing the recordings of 30 subjects performing activities of daily living (ADL) 
while carrying a waist-mounted smartphone with embedded inertial sensors.

The data set is then cleaned and a new data set is created containing the average (grouped by subject and activity) of 
every variable that is a mean or standard deviation calculation of a measurement. 

The code book *CodeBook.Rmd* describes the variables and calculations of the resulting data set.

## Usage

The R script can be executed by sourcing the file:

```{r eval=FALSE}
source('./run_analysis.R', echo=FALSE)
```

### Input

The script takes no arguments and needs no configuration.

### Output

The script generates the following output (i.e. files and directories):

1. File 'UCI_HAR_Dataset.zip' and directory 'UCI HAR Dataset': the downloaded data set.
2. File 'tidy_data.txt': the intermediate tidy data set out of which the data set with the averages is created.
3. File 'average_data.txt': the final data set with the average of the measurement values

These files can be deleted since they will be generated every time the R script is executed.
