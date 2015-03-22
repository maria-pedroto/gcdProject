rm(list=ls());
library("data.table");
library("reshape2");
library("dplyr");
library("downloader");

user_path <- "C:\\GCD\\";

download_file <- function() {
	setwd(user_path);
	path <- getwd();
	setInternet2(TRUE);
	url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
	f <- "Dataset.zip";
	if (!file.exists(path)) {
		dir.create(path);
	}
	download(url, dest=file.path(path, f), mode="wb") 
	unzip (file.path(path, f))

	return(path);
}

fileToDataTable <- function(f) {
    df <- read.table(f);
    dt <- data.table(df);
	
    return(dt);
}

read_datasets <- function(path) {
	pathIn <- file.path(path, "UCI HAR Dataset\\");
	dtSubjectTrain <- fread(file.path(pathIn, "train", "subject_train.txt"));
	dtSubjectTest <- fread(file.path(pathIn, "test", "subject_test.txt"));
	dtActivityTrain <- fread(file.path(pathIn, "train", "Y_train.txt"));
	dtActivityTest <- fread(file.path(pathIn, "test", "Y_test.txt"));
	
	dtTrain <- fileToDataTable(file.path(pathIn, "train", "X_train.txt"));
	dtTest <- fileToDataTable(file.path(pathIn, "test", "X_test.txt"));
	
	return(list(dtTrain, dtTest, pathIn, dtSubjectTrain, dtSubjectTest, dtActivityTrain, dtActivityTest));
}

merge_dataset <- function(dtTrain, dtTest, dtSubjectTrain, dtSubjectTest, dtActivityTrain, dtActivityTest) {
	dtSubject <- rbind(dtSubjectTrain, dtSubjectTest);
	setnames(dtSubject, "V1", "subject");
	dtActivity <- rbind(dtActivityTrain, dtActivityTest);
	setnames(dtActivity, "V1", "activityNum");
	dt <- rbind(dtTrain, dtTest);
	dtSubject <- cbind(dtSubject, dtActivity);
	dt <- cbind(dtSubject, dt);
	setkey(dt, subject, activityNum);
	
	return (dt);
}

#Please upload your data set as a txt file created with write.table() using row.name=FALSE
write_dataset <- function(path, result) {
	write.table(result, paste0(path, "tidy_dataset.txt"));
	
	print(head(result));
	print(paste0(path, "tidy_dataset.txt"));
}

main <- function() {
	#download & save file; 
	path <- download_file();

	#read datasets
	res <- read_datasets(path);
	dsTrain <- res[[1]];
	dsTest <- res[[2]];
	pathIn <- res[[3]];
	dtSubjectTrain <- res[[4]];
 	dtSubjectTest <- res[[5]]; 
	dtActivityTrain <- res[[6]]; 
	dtActivityTest <- res[[7]];
	#merge training and test set
	dt <- merge_dataset(dsTrain, dsTest, dtSubjectTrain, dtSubjectTest, dtActivityTrain, dtActivityTest);
	
	#summary dataset
	dtFeatures <- fread(file.path(pathIn, "features.txt"));
	setnames(dtFeatures, names(dtFeatures), c("featureNum", "featureName"));
	dtFeatures <- dtFeatures[grepl("mean\\(\\)|std\\(\\)", featureName)];
	dtFeatures$featureCode <- dtFeatures[, paste0("V", featureNum)];
	select <- c(key(dt), dtFeatures$featureCode);
	
	dt <- dt[, select, with=FALSE];
	dtActivityNames <- fread(file.path(pathIn, "activity_labels.txt"));
	setnames(dtActivityNames, names(dtActivityNames), c("activityNum", "activityName"));
	dt <- merge(dt, dtActivityNames, by="activityNum", all.x=TRUE);
	setkey(dt, subject, activityNum, activityName);
	dt <- data.table(melt(dt, key(dt), variable.name="featureCode"));
	
	dt <- merge(dt, dtFeatures[, list(featureNum, featureCode, featureName)], by="featureCode", all.x=TRUE);
	dt$activity <- factor(dt$activityName);
	
	dt$feature <- factor(dt$featureName);
	
	n <- 2;
	y <- matrix(seq(1, n), nrow=n);
	x <- matrix(c(grepl("^t", dt$feature), grepl("^f", dt$feature)), ncol=nrow(y));
	
	dt$featDomain <- factor(x %*% y, labels=c("Time", "Freq"));
	x <- matrix(c(grepl("Acc", dt$feature), grepl("Gyro", dt$feature)), ncol=nrow(y));
	dt$featInstrument <- factor(x %*% y, labels=c("Accelerometer", "Gyroscope"));
	x <- matrix(c(grepl("BodyAcc", dt$feature), grepl("GravityAcc", dt$feature)), ncol=nrow(y));
	dt$featAcceleration <- factor(x %*% y, labels=c(NA, "Body", "Gravity"));
	x <- matrix(c(grepl("mean()", dt$feature), grepl("std()", dt$feature)), ncol=nrow(y));
	dt$featVariable <- factor(x %*% y, labels=c("Mean", "SD"));

	dt$featJerk <- factor(grepl("Jerk", dt$feature), labels=c(NA, "Jerk"));
	dt$featMagnitude <- factor(grepl("Mag", dt$feature), labels=c(NA, "Magnitude"));

	n <- 3
	y <- matrix(seq(1, n), nrow=n);
	x <- matrix(c(grepl("-X", dt$feature), grepl("-Y", dt$feature), grepl("-Z", dt$feature)), ncol=nrow(y))
	dt$featAxis <- factor(x %*% y, labels=c(NA, "X", "Y", "Z"))
	r1 <- nrow(dt[, .N, by=c("feature")]);
	r2 <- nrow(dt[, .N, by=c("featDomain", "featAcceleration", "featInstrument", "featJerk", "featMagnitude", "featVariable", "featAxis")]);

	setkey(dt, subject, activity, featDomain, featAcceleration, featInstrument, featJerk, featMagnitude, featVariable, featAxis)
	dtTidy <- dt[, list(count = .N, average = mean(value)), by=key(dt)];
	
	str(dtTidy);
	key(dtTidy);
	head(dtTidy);
	summary(dtTidy);
	
	write_dataset(path, dtTidy);
}

main();
