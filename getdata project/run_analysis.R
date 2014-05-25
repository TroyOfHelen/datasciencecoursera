a="UCI HAR Dataset"
if(!file.exists(a)) {
  b="getdata-projectfiles-UCI HAR Dataset.zip"
  if(!file.exists(b)){
    url="http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(url=url,destfile=b)
  }
  unzip(b)
}

b="UCI HAR Dataset/test/subject_test.txt"
subject_test=read.csv(file=b,header=F,col.names=c("subject"))

b="UCI HAR Dataset/test/y_test.txt"
activity_test=read.csv(file=b,header=F,col.names=c("activity"))

b="UCI HAR Dataset/train//subject_train.txt"
subject_train=read.csv(file=b,header=F,col.names=c("subject"))

b="UCI HAR Dataset/train/y_train.txt"
activity_train=read.csv(file=b,header=F,col.names=c("activity"))

b <- "UCI HAR Dataset//activity_labels.txt"
activity_labels <- read.table(file=b,sep="",header=F,col.names=c("id","activity"))[[2]]

b <- "UCI HAR Dataset//features.txt"
feature_labels <- read.csv(file=b,sep=" ",header=F,col.names=c("id","feature"))[[2]]
feature_labels <- as.character(feature_labels)

ms=grep(pattern="mean|std",x=feature_labels)
feature_labels[ms]

b="UCI HAR Dataset/test/X_test.txt"
test=read.table(file=b,header=F,sep="",row.names=NULL)[,ms]

b="UCI HAR Dataset/train/X_train.txt"
train=read.table(file=b,header=F,sep="",row.names=NULL)[,ms]

names(test)=feature_labels[ms]
test$subject = subject_test[[1]]
test$activity = activity_test[[1]]


names(train)=feature_labels[ms]
train$subject = subject_train[[1]]
train$activity = activity_train[[1]]


f=length(train[[1]])
g=length(test[[1]])

test$train_or_test=replicate(g,1)
train$train_or_test=replicate(f,2)
d=rbind(train,test)
#d=merge(train,test,all.x=T,all.y=T)
# http://stackoverflow.com/questions/22766738/r-rbind-error-row-names-duplicates-not-allowed


rm(list=c("test","train"))

d$train_or_test = as.factor(d$train_or_test)
levels(d$train_or_test)
levels(d$train_or_test) = c("test","train")
str(d)

d$activity=as.factor(d$activity)
levels(d$activity)=levels(activity_labels)

d$subject=as.factor(d$subject)
levels(d$subject)

require(rhdf5)
b="samsung_data_tidy_project.h5"
h5createFile(file=b)
h5write(obj=d,file=b,name="samsung_data")
h5ls(b)


f=aggregate(formula=.~activity+subject,FUN=mean,data=d)

b="samsung_data_tidy_project_aggregate.h5"
h5createFile(file=b)
h5write(obj=f,file=b,name="samsung_data_aggregate")
h5ls(b)
