#downoading and saving data in folder named "data"

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")

unzip(zipfile="./data/Dataset.zip",exdir="./data")

#getting the lis of files in "UCI HAR Dataset"
path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)
files

#reading activity files (both train and test)
dataActivityTest<-read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain<-read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)

#read subject files (both train and test)
dataSubjectTrain<-read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest<-read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)

#read feature files (both train and test)
dataFeaturesTest<-read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain<-read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)

#join Test and Train tables wth rbind 
dataSubject<-rbind(dataSubjectTrain,dataSubjectTest)
dataActivity<-rbind(dataActivityTrain,dataActivityTest)
dataFeatures<-rbind(dataFeaturesTrain,dataFeaturesTest)

#give names to variables
# 
names(dataSubject)<-c("subject")
names(dataActivity)<-c("activity")

#getting features names from "features.txt" file
#renaming v1, v2 etc to whatever the details given in text
dataFeaturesNames<-read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(dataFeatures)<-dataFeaturesNames$V2

#Merging the columns of dataSubject, dataActivity & dataFeatures (datafeatureNames is only for names)
data<-cbind(dataSubject,dataActivity,dataFeatures)

#merging all innertial signals 
dataacc_x_test<-read.table("body_acc_x_test.txt",head=FALSE)
dataacc_y_test<-read.table("body_acc_y_test.txt",head=FALSE)
dataacc_z_test<-read.table("body_acc_z_test.txt",head=FALSE)
dataacc<-rbind(dataacc_x_test,dataacc_y_test,dataacc_z_test)

datagyro_x_test<-read.table("body_gyro_x_test.txt",head=FALSE)
datagyro_y_test<-read.table("body_gyro_y_test.txt",head=FALSE)
datagyro_z_test<-read.table("body_gyro_z_test.txt",head=FALSE)
datagyro<-rbind(datagyro_x_test,datagyro_y_test,datagyro_z_test)

datatotacc_x_test<-read.table("total_acc_x_test.txt",head=FALSE)
datatotacc_y_test<-read.table("total_acc_y_test.txt",head=FALSE)
datatotacc_z_test<-read.table("total_acc_z_test.txt",head=FALSE)
datatotacc<-rbind(datatotacc_x_test,datatotacc_y_test,datatotacc_z_test)

datainertialTest<-rbind(dataacc,datagyro,datatotacc) 

#entering train folder to access train text files
setwd("~/Desktop/CE/getting and cleaning data/Project/data/UCI HAR Dataset/train/Inertial Signals")

dataacc_x_train<-read.table("body_acc_x_train.txt",head=FALSE)
dataacc_y_train<-read.table("body_acc_y_train.txt",head=FALSE)
dataacc_z_train<-read.table("body_acc_z_train.txt",head=FALSE)
dataacctrain<-rbind(dataacc_x_train,dataacc_y_train,dataacc_z_train)

datagyro_x_train<-read.table("body_gyro_x_train.txt",head=FALSE)
datagyro_y_train<-read.table("body_gyro_y_train.txt",head=FALSE)
datagyro_z_train<-read.table("body_gyro_z_train.txt",head=FALSE)
datagyrotrain<-rbind(datagyro_x_train,datagyro_y_train,datagyro_z_train)

datatotacc_x_train<-read.table("total_acc_x_train.txt",head=FALSE)
datatotacc_y_train<-read.table("total_acc_y_train.txt",head=FALSE)
datatotacc_z_train<-read.table("total_acc_z_train.txt",head=FALSE)
datatotacctrain<-rbind(datatotacc_x_train,datatotacc_y_train,datatotacc_z_train)

datainertialtrain<-rbind(dataacctrain,datagyrotrain,datatotacctrain)

      datainertial<-rbind(datainertialTest,datainertialtrain) #complete datainertial dataset


#Extracts only the measurements on the mean and standard deviation for each measurement
#display only column names which has  the words mean(), std()
#2 use regular exp to match mean() std() 

meanstd<-grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)
meanstdcol<-dataFeaturesNames$V2[meanstd]
#meanstdcol has all colnames with words mean & std
meanstd1<-c(as.character(meanstdcol), "subject", "activity" )
#subset meanstd1 out of "data" table
subsetdata<-subset(data,select=meanstd1) #subsetdata has only columns with strings "mean" & "std"

#3 Uses descriptive activity names to name the activities in the data set
#activities are in numbers.. extract the names from activity_lables.txt &dump it in one file
setwd("~/Desktop/CE/getting and cleaning data/Project/data/UCI HAR Dataset")

activityLabels<-read.table("activit_labels.txt") #activityLables contain lables for 1-6
finaldata<-merge(activityLabels, data, by.x = "V1", by.y = "activity")
#extra column V1 is present, removing that in next step
finaldata$V1<-NULL
#renaming V2 column name to "activity"
names(finaldata)<-gsub("V2", "activity", names(finaldata))
View(finaldata) #finaldata df has activity names instead of 1,2..6

#4 Appropriately labels the data set with descriptive variable names.

names(finaldata)<-gsub("^t", "time", names(finaldata))
names(finaldata)<-gsub("^f", "frequency", names(finaldata))
names(finaldata)<-gsub("Acc", "Accelerometer", names(finaldata))
names(finaldata)<-gsub("Gyro", "Gyroscope", names(finaldata))
names(finaldata)<-gsub("Mag", "Magnitude", names(finaldata))
names(finaldata)<-gsub("BodyBody", "Body", names(finaldata))

colnames(finaldata) #now subsetdata contains all detailed colum names 
View(finaldata)

#5From the data set in step 4, creates a second, independent tidy data
#set with the average of each variable for each activity and each subject

tidy<-aggregate(. ~subject + activity, finaldata, mean)
tidy<-tidy[order(tidy$subject,tidy$activity),]
View(tidy)
#writing it in a csv file, UCIHARdata.csv contains the tidy data set
write.table(tidy, file = "UCIHARdata.txt",row.name=FALSE)
  
   #creating codebook
library(dataMaid)
library(rmarkdown)
makeCodebook(tidy)
 
