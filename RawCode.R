# Functions: 

## 

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

## Calculate and report the mean and median total number of steps taken per day

round(mean(steps_daily$Steps, na.rm=T))
round(median(steps_daily$Steps, na.rm=T))

# Imputing missing values

## Calculate and report the total number of missing values in the dataset 
## (i.e. the total number of rows with NAs)

missingvalues <- which(rowSums(is.na(df))>0)

##  Devise a strategy for filling in all of the missing values in the dataset. 
## The strategy does not need to be sophisticated. For example, you could use 
## the mean/median for that day, or the mean for that 5-minute interval, etc.
## & 
## Create a new dataset that is equal to the original dataset but with the missing 
## data filled in.

dfNA <-df[missingvalues,]
dfNoNA <- df[-(missingvalues),]
dfNA$steps <- NULL
steps_median_5minutes <- aggregate(dfNoNA$steps, list(dfNoNA$interval), FUN=median)
names(steps_median_5minutes) <- c("interval", "steps")
dfNA <- merge(x = dfNA, y = steps_median_5minutes, by = "interval", all.x=TRUE)
df_new <- rbind(dfNA,dfNoNA)

## Make a histogram of the total number of steps taken each day and Calculate and 
## report the mean and median total number of steps taken per day. Do these values 
## differ from the estimates from the first part of the assignment? What is the 
## impact of imputing missing data on the estimates of the total daily number of steps?

steps_sum_day <- aggregate(df_new$steps, list(df_new$date), FUN=sum)
hist(steps_sum_day$steps,steps_sum_day$date)
round(mean(steps_sum_day, na.rm=T))
round(median(steps_sum_day, na.rm=T))

# What is the average daily activity pattern?

## Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and 
## the average number of steps taken, averaged across all days (y-axis)

 <- df[]
steps_median_5minutes <- aggregate(df$steps, list(df$interval), FUN=median)



## 