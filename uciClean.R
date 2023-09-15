filename <- "UCI HAR Dataset.zip"

# Checking if archieve already exists.
if (!file.exists(filename)){
  link <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(link, filename, method="curl")
} 

if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

activity <- read.table("~/Desktop/Corsera/Cleaning Data/UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
features <- read.table("~/Desktop/Corsera/Cleaning Data/UCI HAR Dataset/features.txt", col.names = c("feat_num", "feature"))
subject_test <- read.table("~/Desktop/Corsera/Cleaning Data/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("~/Desktop/Corsera/Cleaning Data/UCI HAR Dataset/test/X_test.txt", col.names = features$feature)
y_test <- read.table("~/Desktop/Corsera/Cleaning Data/UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("~/Desktop/Corsera/Cleaning Data/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("~/Desktop/Corsera/Cleaning Data/UCI HAR Dataset/train/X_train.txt", col.names = features$feature)
y_train <- read.table("~/Desktop/Corsera/Cleaning Data/UCI HAR Dataset/train/y_train.txt", col.names = "code")


x_merged <- rbind(x_train, x_test)
y_merged <- rbind(y_train, y_test)
subject_merged <- rbind(subject_test, subject_train)
mergedData <- cbind(subject_merged, y_merged, x_merged)
activityData <- mergedData %>% select(subject, code, contains("mean"), contains("std"))

activityData$code <- factor(activityData$code,
                         levels = activity[,1],
                         labels = activity[,2])
activityData$subject  <- as.factor(activityData$subject) 

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


meanData <- activityData %>% 
  group_by(subject, code) %>% 
  summarise_all(tibble::lst(mean))

write.table(meanData, file = "./meanData.txt", row.names = FALSE, col.names = TRUE) 
