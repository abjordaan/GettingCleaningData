# Peer-graded Assignment: Getting and Cleaning Data Course Project

## Contents

- `README.md` - This file
- `Codebook` - describes the script processes to generate the tidy data set from the raw data.
- `run_analysis.R` - R script that download, unzip, load, merge and clean the data.
- `tidy_df.txt` - Tidy data set after the run_analysis.R script has been applied.

## Prerequisites

- The script will load the required libraries but will not install them. Please install the libraries before runnig the run_analysis.R script: plyr & dplyr
- The scritp will download the file into the current R working directory thus there is no need to
- The script will download the [source data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) 
- A description of the raw dataset can be found [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

There is no need to put extracts of the scripts in the codebook as the run_analysis.R file is well commented.

## How the script works

### 1 - Collect and prepare the data
`REQUIREMENT: Merges the training and the test sets to create one data set`

Reading the data from the raw data file and perform a few actions on the data in order to prepare it for data analysis. 

#### Steps in the run_analysis.R script

 - Download and extract the source data from the [internet](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).
 - Load all the data into seperate data frames. There are multiple files in multiple directories. 
 - Combine the 'test' and 'training' data for each set into a single data frame. The srtucture of the training and test data sets are the same.
 - Issue cleanup on the column names in the "subject" and "labels" data frames. 
 - The "features.txt" file contains a mapping of the column names of the set data. Set the names on the data sets based on the features file.
 - Combine the subject, labels and sets data frames.
 
### 2 - Extract the data of interest
`REQUIREMENT: Extracts only the measurements on the mean and standard deviation for each measurement`

The analysis does not need to be done on the entire merged data sets. The columns of interest are any column containg the word or phrase mean() or std().

#### Steps in the run_analysis.R script
- Use the grep command and a regular expression to extract he column id's.
- Extract a subset of the columns based on the above columns id's.
 
### 3 - Replace activity ID with name column
`REQUIREMENT: Uses descriptive activity names to name the activities in the data set`
 
The activity labels are stored in a file whic are mapped to the activity id in the data set. The script will use this file to replace the activity id's with a more descriptive name.
 
#### Steps in the run_analysis.R script 
- Read the content of the activity labels file into a data frame.
- merge the activity labels into the subset data frame on the "activity" column.
 
### 4 - Modify column labels to be more descriptive
`REQUIREMENT: Appropriately labels the data set with descriptive variable names`

The column lables of the raw data is not tidy. The current clumn names contais characters that needs to be btter described.

#### Steps in the run_analysis.R script
- The R command gsub is used to rename or remove characters from the names in teh subset data set.
- The following regular expressios apply:

\# | Raw Name | Tidy Name | Descrption
--- | --- | --- | ---
1 | mean() | Mean | Replace any name containg "mean()" with "Mean" 
2 | std() | StdDeviation | Replace any name containg "std()" with "StdDeviation"
3 | ^t | Time | Replace starting lowercase "t" with "Time"
4 | ^f | Frequency | Replace starting lowercase "f" with "Frequency"
5 | BodyBody | Body | Replace doube "BodyBody" with single "Body"
6 | ^a | A | Replace starting lowercase "a" with uppercase "A"
7 | - |   | Remove "-"
8 | ^s | S | eplace starting lowercase "s" with uppercase "S"

- Sample of column name changes in the raw data and the changes in the tidy data:

Raw Name | Tidy Name
--- | --- 
tBodyAcc-mean()-X | TimeBodyAccMeanX
fBodyAcc-mean()-X | FrequencyBodyAccMeanX
fBodyBodyGyroMag-mean() | FrequencyBodyGyroMagMean
fBodyBodyGyroMag-std() | FrequencyBodyGyroMagStdDeviation
subject | Subject
activity | Activity

### 5 - Export to independant tidy data set
`REQUIREMENT: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject`

Export a summary of the mean per subject and activity.

#### Steps in the run_analysis.R script

- Call the ddply fuction on the subset data frame and calculate the mean per subject and activity into a new data frame.
- Write the new data frame to a file. Dimensions of the data frame shown below. 

```r
dim(tidy_df)
[1] 180  69
```
