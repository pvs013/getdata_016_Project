##  -----------------------------------------------------------
##  R - Getting and Cleaning Data - Class Project
##  Chris Palmer
##  12/21/14
##  
##  -----------------------------------------------------------

## Get the Original Data Set
url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile="./data/human_act_recg.zip", mode="wb")
unzip("./data/human_act_recg.zip")
dataDownloaded <- date() 
dataDownloaded

## Read in the Test Data
Xtest <- read.table("UCI HAR Dataset/test/X_test.txt") ##, sep=" ", na.strings=" ")
ytest <- read.table("UCI HAR Dataset/test/y_test.txt")
Stest <- read.table("UCI HAR Dataset/test/subject_test.txt")
Test <- cbind(Xtest, ytest, Stest)
## clean up
remove(Xtest, ytest, Stest)

## Read in the Train Data
Xtrain <- read.table("UCI HAR Dataset/train/X_train.txt") ##, sep=" ", na.strings=" ")
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt")
Strain <- read.table("UCI HAR Dataset/train/subject_train.txt")
Train <- cbind(Xtrain, ytrain, Strain)
## clean up
remove(Xtrain, ytrain, Strain)

## Merge Test and Train DSETs
dset <- rbind(Test, Train)
## clean up
remove(Test, Train)

## Read in the Feature Text
FeaturesText <- read.table("UCI HAR Dataset/features.txt") 
v <- as.vector(FeaturesText[,2])  
v <- c(v, "Activity","Subject")
dset <- setNames(dset, v)

## subset the Means (mean, std) 
##   also the Activity and Subject columns
dset <- dset[,grep("mean|std|Activity|Subject", v)]

## Read in Activities File
ActivityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")

## Join/Merge label with Data Set
dsetl <- merge(dset, ActivityLabels, by.x="Activity", by.y="V1", all=TRUE)
## remove Activity index, not needed,  Correct the column name
dsetl <- dsetl[,2:82]
names(dsetl)[81] <- "Activity"

## use the DPLYR package to Group by Activity and Subject, 
##   and Average the columns
library(dplyr)
data <- tbl_df(dsetl)
final_sum <- data %>%
    group_by(Activity, Subject) %>%
    summarise_each(funs(mean))

## Write out data
write.table(final_sum, file="ActivitySummary.txt", row.name=FALSE)

