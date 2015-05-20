#####     runanalysis.R    #######
#Import features list
features <- read.table("features.txt", quote="\"")
featurelist<-features[,2]

#Import Activity labels list
activity_labels <- read.table("activity_labels.txt", quote="\"")
colnames(activity_labels)<-c("ActivityID","ActivityDescription")

#####Import Test data######
subject_test <- read.table("subject_test.txt", quote="\"")
X_test <- read.table("X_test.txt", quote="\"")
y_test <- read.table("y_test.txt", quote="\"")

#Combine all columns of test data
testdata<-cbind(y_test,X_test)
testdata<-cbind(subject_test,testdata)
colnames(testdata)<-c("SubjectID","ActivityID",as.character(featurelist))

####Import Train data#####
subject_train <- read.table("subject_train.txt", quote="\"")
X_train <- read.table("X_train.txt",quote="\"")
y_train <- read.table("y_train.txt",quote="\"")

#Combine all columns of train data
traindata<-cbind(y_train,X_train)
traindata<-cbind(subject_train,traindata)
colnames(traindata)<-c("SubjectID","ActivityID",as.character(featurelist))

#########Merge the training and the test sets to create one data set##########
#Combine test and train
tidydataset<-rbind(testdata,traindata)    

#Add Activity description associated with Activity ID
tidydataset$ActivityDescription<-activity_labels[match(tidydataset$ActivityID, activity_labels$ActivityID),2]

#select only mean and std columns for each observation
sel<-setdiff(grep("mean|std",colnames(tidydataset)),grep("meanFreq",colnames(tidydataset)))

#FINAL DATASET CREATED
final<-tidydataset[,c(1,2,564,sel)]
  #Has merged data from train and test sets
  #Activity Description is present
  #Only Contains mean and std measurements

#### create independent tidy data set with average of each variable ######
###for each activity and each subject

averagedataset<-final[,c(1,3,4:69)] %>% group_by(ActivityDescription,SubjectID) %>% summarise_each(funs(mean))
write.table(averagedataset,"FinalAverageData.txt",row.names=F)
#this is another way but first one gives the proper format of tidy data
#melted<-melt(final[,c(1,3,4:69)],id=c("SubjectID","ActivityDescription"))
#averagedataset<-ddply(melted, .(SubjectID,ActivityDescription,variable) ,summarize,average=mean(value))