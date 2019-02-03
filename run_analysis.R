require(data.table)
require(dplyr)
require(plyr)
require(knitr)


setwd("D:/GDrive/Codz/R/RnD/")

filename <- "DC_Project_Dataset.zip"

#Checking if archieve already exist.
if(!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename)
}

#Checking if folder exists
if(!file.exists("UCI HAR Dataset")){
  unzip(filename)
}

# Get list of the files
path_ref <- file.path("D:/GDrive/Codz/R/RnD/", "UCI HAR Dataset")
files <- list.files(path_ref, recursive = T)

# Read the Activity files
dataActivityTest  <- read.table(file.path(path_ref, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(path_ref, "train", "Y_train.txt"),header = FALSE)

# Read the Subject files
dataSubjectTrain <- read.table(file.path(path_ref, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(path_ref, "test" , "subject_test.txt"),header = FALSE)

#Read Fearures files

dataFeaturesTest  <- read.table(file.path(path_ref, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_ref, "train", "X_train.txt"),header = FALSE)

# Sructure of variables
str(dataActivityTest)
str(dataActivityTrain)
str(dataSubjectTrain)
str(dataSubjectTest)
str(dataFeaturesTest)
str(dataFeaturesTrain)

# Merging Datasets
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

# set names to variable
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(path_ref, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

# Merging columns to get dataframe
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)


#mean and std
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

# subsetting dataset
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)

#look structure
str(Data)

# descriptive activity names from “activity_labels.txt”
activityLabels <- read.table(file.path(path_ref, "activity_labels.txt"),header = FALSE)

head(Data$activity,30)

# sutaible labels the data set with descriptive variable names
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))


# Creates a second,independent tidy data set and ouput it
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)





