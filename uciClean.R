#load dplyr library
library(dplyr)

#name the file
filename <- "UCI HAR Dataset.zip"

# Find the file in working directory and downloads it if not available
if (!file.exists(filename)){
  link <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(link, filename, method="curl")
} 

if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

# loads .txt files and adds an id to combine like data
activity <- read.table("~/Desktop/Corsera/Cleaning Data/UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
features <- read.table("~/Desktop/Corsera/Cleaning Data/UCI HAR Dataset/features.txt", col.names = c("feat_num", "feature"))
subject_test <- read.table("~/Desktop/Corsera/Cleaning Data/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("~/Desktop/Corsera/Cleaning Data/UCI HAR Dataset/test/X_test.txt", col.names = features$feature)
y_test <- read.table("~/Desktop/Corsera/Cleaning Data/UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("~/Desktop/Corsera/Cleaning Data/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("~/Desktop/Corsera/Cleaning Data/UCI HAR Dataset/train/X_train.txt", col.names = features$feature)
y_train <- read.table("~/Desktop/Corsera/Cleaning Data/UCI HAR Dataset/train/y_train.txt", col.names = "code")

# merge the x data
x_merged <- rbind(x_train, x_test)
# merge the y data
y_merged <- rbind(y_train, y_test)
# merge the subject data
subject_merged <- rbind(subject_test, subject_train)
#merge x, y, and subject data across columns and puts the subject and code first to make it easy to find
mergedData <- cbind(subject_merged, y_merged, x_merged)
#select only the variables that contain the subject, code, means, and standard deviations
activityData <- mergedData %>% select(subject, code, contains("mean"), contains("std"))

#create levels for the codes for the different activity types using the activity labels file
activityData$code <- factor(activityData$code,
                         levels = activity[,1],
                         labels = activity[,2])
activityData$subject  <- as.factor(activityData$subject) 

# make columns readable by replacing abbreviations, capitalizing words, and removing symbols
colnames(activityData) <- gsub("\\.", "", names(activityData))
colnames(activityData) <- gsub('^t', 'Time', colnames(activityData))
colnames(activityData) <- gsub('tB', 'TimeBody', colnames(activityData))
colnames(activityData) <- gsub('^f', 'Frequency', colnames(activityData))
colnames(activityData) <- gsub('Acc', 'Accelerometer', colnames(activityData))
colnames(activityData) <- gsub('Gyro', 'Gryoscope', colnames(activityData))
colnames(activityData) <- gsub('Mag', 'Magnitude', colnames(activityData))
colnames(activityData) <- gsub('BodyBody', 'Body', colnames(activityData))
colnames(activityData) <- gsub('mean', 'Mean', colnames(activityData))
colnames(activityData) <- gsub('std', 'Std', colnames(activityData))
colnames(activityData) <- gsub('angle', 'Angle', colnames(activityData))

# find the means for each activity for each subject
meanData <- activityData %>% 
  group_by(subject, code) %>% 
  summarise_all(tibble::lst(mean))

# create a .txt file with the new tidy data
write.table(meanData, file = "./meanData.txt", row.names = FALSE, col.names = TRUE) 
