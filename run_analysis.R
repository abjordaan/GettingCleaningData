# -------------------------------------------------------------------------------------------
# 0 - Load libraries, download and extract the data
# -------------------------------------------------------------------------------------------

# Load the required libraries
library(plyr)
library(dplyr)

# Create data directory if not exist
if(!file.exists("./har_data")){dir.create("./har_data")}

# Set file URL
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# Download File
download.file(fileUrl,destfile="./har_data/har_dataset.zip",method="curl")

# Extract the data
unzip(zipfile="./har_data/har_dataset.zip",exdir="./har_data")

# -------------------------------------------------------------------------------------------
# 1 - Merges the training and the test sets to create one data set.
# -------------------------------------------------------------------------------------------

# Load test and training labels
labelTrain_Y <- read.table("./har_data/UCI HAR Dataset/train/Y_train.txt", header = FALSE)
labelTest_Y  <- read.table("./har_data/UCI HAR Dataset/test/Y_test.txt", header = FALSE)

# Load test and training subjects
subjectTrain <- read.table("./har_data/UCI HAR Dataset/train/subject_train.txt", header = FALSE)
subjectTest  <- read.table("./har_data/UCI HAR Dataset/test/subject_test.txt", header = FALSE)

# load test and training sets
setTrain <- read.table("./har_data/UCI HAR Dataset/train/X_train.txt", header = FALSE)
setTest  <- read.table("./har_data/UCI HAR Dataset/test/X_test.txt", header = FALSE)

# Combine training and test data for label and set column names
lables_df <- rbind(labelTrain_Y, labelTest_Y)
names(lables_df)<- c("activity")

# Combine training and test data for subject and set column names
subject_df <- rbind(subjectTrain, subjectTest)
names(subject_df)<-c("subject")

# Combine training and test data for sets and set column names according to features.txt
set_df <- rbind(setTrain, setTest)
names(set_df) <- read.table("./har_data/UCI HAR Dataset/features.txt",head=FALSE)[,2]

# Merge data frames
# Bind lables_df and subject_df then set_df
df <- cbind(subject_df, lables_df)
data_frame <- cbind(set_df,df)

# -------------------------------------------------------------------------------------------
# 2 - Extracts only the measurements on the mean and standard deviation for each measurement.
# -------------------------------------------------------------------------------------------

# Get column id's for columns containg worsd in the regex.
x <- grep("mean\\(\\)|std\\(\\)|activity|subject", names(data_frame))
sub_df <- data_frame[,x]

# -------------------------------------------------------------------------------------------
# 3 - Uses descriptive activity names to name the activities in the data set.
# -------------------------------------------------------------------------------------------

activities_df <- read.table("./har_data/UCI HAR Dataset/activity_labels.txt")
names(activities_df) <- c("activity","ActivityDescription")

sub_df <- merge(sub_df, activities_df, by="activity", all.x=TRUE)

# -------------------------------------------------------------------------------------------
# 4 - Appropriately labels the data set with descriptive variable names.
# -------------------------------------------------------------------------------------------

# Use gsub and regex to rename and clean up the column hears in the data frame
names(sub_df) <- gsub("mean\\(\\)", "Mean", names(sub_df))
names(sub_df) <- gsub("std\\(\\)", "StdDeviation", names(sub_df))
names(sub_df) <- gsub("^t", "Time", names(sub_df))
names(sub_df) <- gsub("^f", "Frequency", names(sub_df))
names(sub_df) <- gsub("BodyBody", "Body", names(sub_df))
names(sub_df) <- gsub("^a", "A", names(sub_df))
names(sub_df) <- gsub("-", "", names(sub_df))
names(sub_df) <- gsub("^s", "S", names(sub_df))

# -------------------------------------------------------------------------------------------
# 5 - From the data set in step 4, creates a second, independent tidy data set 
#     with the average of each variable for each activity and each subject.
# -------------------------------------------------------------------------------------------

tidy_df <- ddply(sub_df,c("Subject","ActivityDescription"), numcolwise(mean))
write.table(tidy_df, "tidy_df.txt", row.names = TRUE)



