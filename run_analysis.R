cat("\f")   
library(dplyr)

setwd("C:\\Users\\Aner\\Desktop\\DATA_SCIENCE_SPECIALIZATION\\3_Getting_And_Cleaning_Data\\W4__Project\\UCI HAR Dataset")

X_train <-read.table("./train/X_train.txt")  ###  7352X561 features
y_train <- read.table("./train/y_train.txt")  ###  7352X1
sbj_train<-read.table("./train/subject_train.txt")###  7352X1
X_test<-read.table("./test/X_test.txt")     ###  2947X561 features
y_test<-read.table("./test/y_test.txt")    ### 2947X1
sbj_test<-read.table("./test/subject_test.txt") ### 2947X1


### (1) Merges the training and the test sets to create one data set.
SBJ<-rbind(sbj_train, sbj_test)### 10299X1 [1 col of subject id:  1-30]
CLASS<-rbind(y_train,y_test) ### 10299X1 [1 col of activity id 1-6: wlk, sit, etc]
FEAT<-rbind(X_train, X_test) ### 10299X561 [each col is a feature]

### (3) Uses descriptive activity names to name the activities in the data set
activity_labels<-read.table("activity_labels.txt")#####  2X6
colnames(activity_labels)<-c("activityID","activityNAME")
CLASS_with_NAMES <- merge(x=CLASS, y=activity_labels, by="activityID")

DATA<-cbind(SBJ,CLASS_with_NAMES,FEAT)

### (2) Extracts only the measurements on the mean and standard deviation for each measurement.
FEATmean<-colMeans(FEAT, na.rm = TRUE)
FEATsd=apply(FEAT,2,sd)

### (4) Appropriately labels the data set with descriptive variable names.
FEAT_labels<-read.table("features.txt")#####  2X6
colnames(FEAT_labels)<-c("featureID","featureNAME")
FEAT_NAMES<-make.names(FEAT_labels$featureNAME, unique=TRUE)
colnames(DATA)<-c("sbjID","activityID","activityNAME", FEAT_NAMES)

### (5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
AV <- summarise_each(group_by(DATA, sbjID, activityNAME), funs(mean))

write.table(AV, file="tidy.txt", row.names=FALSE, col.names=TRUE, sep="\t", quote=TRUE)