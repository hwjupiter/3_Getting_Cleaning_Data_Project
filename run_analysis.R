#load the libraries that are useful for handling large data tables
library(dplyr)

# Load the URL and filenames for the dataset
data_URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
data_file <- "UCI HAR Dataset.zip"
data_path <- "UCI HAR Dataset"

#check if the file exists. If not, download and unzip it
if (!file.exists(data_file)) {
    download.file(data_URL, data_file)
    unzip(data_file)
}

#read in the training data
training_subjects <- read.table(file.path(data_path, "train", "subject_train.txt"))
training_data <- read.table(file.path(data_path, "train", "X_train.txt"))
training_labels <- read.table(file.path(data_path, "train", "Y_train.txt"))
#put all the training data into one table
training_table <- cbind(training_subjects, training_data, training_labels)

#read in the test data
test_subjects <- read.table(file.path(data_path, "test", "subject_test.txt"))
test_data <- read.table(file.path(data_path, "test", "X_test.txt"))
test_labels <- read.table(file.path(data_path, "test", "Y_test.txt"))
#put all the test data into one table
test_table <- cbind(test_subjects, test_data, test_labels)

#read in details about the activities performed, and assign meaningful column names
activities_data <- read.table(file.path(data_path, "activity_labels.txt"))
colnames(activities_data) <- c("ID", "Description")

#read in details about features
features_data <- read.table(file.path(data_path, "features.txt"), as.is = TRUE)

#merge the training and test data into one table, and assign meaningful column names
total_data <- rbind(training_table, test_table)
colnames(total_data) <- c("Subject_ID", features_data[,2], "Activity")

#search for any columns that have Mean or Std in the name and keep only these
columns_needed <- grep(".*Mean.*|.*Std.*", names(total_data), ignore.case = TRUE)
data_to_keep <- total_data[,c(1, 563, columns_needed)]

#change the data type of the Activity column data from integer to character
data_to_keep$Activity <- as.character(data_to_keep$Activity)
# replace the integer values with the original names as given in the activity text file
for (i in 1:6){
    data_to_keep$Activity[data_to_keep$Activity == i] <- as.character(activities_data[i,2])
}
data_to_keep$Activity <- as.factor(data_to_keep$Activity)

#replace abbreviations used in the features names with complete descriptions to aid readability
names(data_to_keep) <- gsub("Acc", "Acceleration", names(data_to_keep))
names(data_to_keep) <- gsub("Gyro", "Gyroscope", names(data_to_keep))
names(data_to_keep) <- gsub("^t", "Time", names(data_to_keep))
names(data_to_keep) <- gsub("^f", "Frequency", names(data_to_keep))
names(data_to_keep) <- gsub("Freq", "Frequency", names(data_to_keep))
names(data_to_keep) <- gsub("Mag", "Magnitude", names(data_to_keep))
names(data_to_keep) <- gsub("BodyBody", "Body", names(data_to_keep))
names(data_to_keep) <- gsub("std", "Standard Deviation", names(data_to_keep))

#create a new data table from the extracted data
data_to_keep$Subject_ID<- as.factor(data_to_keep$Subject_ID)
#data_to_keep <- data.table(data_to_keep)

#using the new data table, calculate the mean value of the various features across subjects and activities
new_tidy_data <- aggregate(. ~ Subject_ID + Activity, data_to_keep, mean)
new_tidy_data <- new_tidy_data[order(new_tidy_data$Subject_ID, new_tidy_data$Activity),]

#write out the new tidy dataset to a text file
write.table(new_tidy_data, "new_tidy_data.txt", row.names = FALSE)
