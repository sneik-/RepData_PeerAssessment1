# Loading and preprocessing the data 1 & 2

## Load the data (i.e. read.csv())
unzip("activity.zip")
df <- read.csv("activity.csv")

## Process/transform the data (if necessary) into a format suitable for your analysis

##???

# What is mean total number of steps taken per day?

## Make a histogram of the total number of steps taken each day

steps_daily <- aggregate(df$steps, list(df$date), FUN=sum)
names(steps_daily) <- c("Date","Steps")
hist(steps_daily$Steps, breaks=30, xlab="Daily steps", main="Histogram of daily steps")
 
# Imputing missing values

## Calculate and report the total number of missing values in the dataset 
## (i.e. the total number of rows with NAs)

rowSums(is.na(df))

## 