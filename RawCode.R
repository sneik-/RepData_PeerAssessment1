# load libraries

install.packages("ggplot2")
library(ggplot2)
install.packages("reshape")
library(reshape)

## 

# Loading and preprocessing the data

## 1. Load the data (i.e. read.csv())
unzip("activity.zip")
df <- read.csv("activity.csv")

## 2. Process/transform the data (if necessary) into a format suitable for your 
## analysis.
## Made the aggregation needed later here.

missingvalues <- which(rowSums(is.na(df))>0)
dfNA <-df[missingvalues,]
dfNoNA <- df[-(missingvalues),]
dfNA$steps <- NULL
steps_mean_5minutes <- aggregate(dfNoNA$steps, list(dfNoNA$interval), 
                                   FUN=mean)
names(steps_mean_5minutes) <- c("interval", "steps")
#steps_median_5minutes <- aggregate(dfNoNA$steps, list(dfNoNA$interval), 
#                                   FUN=median)
#names(steps_median_5minutes) <- c("interval", "steps")

# What is mean total number of steps taken per day?

## 1. Make a histogram of the total number of steps taken each day

steps_daily <- aggregate(df$steps, list(df$date), FUN=sum)
names(steps_daily) <- c("Date","Steps")
hist(steps_daily$Steps, breaks=30, xlab="Daily steps", 
     main="Histogram of daily steps")

##  2. Calculate and report the mean and median total number of steps taken 
## per day

round(mean(steps_daily$Steps, na.rm=T))
round(median(steps_daily$Steps, na.rm=T))

# What is the average daily activity pattern?

## 1. Make a time series plot (i.e. type = "l") of the 5-minute interval 
## (x-axis) and the average number of steps taken, averaged across all days 
## (y-axis)

ggplot(steps_mean_5minutes, aes(x=interval, y=steps)) +geom_line()


## Which 5-minute interval, on average across all the days in the dataset, 
## contains the maximum number of steps?

maxSteps <- max(steps_mean_5minutes$steps)
mostActiveInterval <- subset(steps_mean_5minutes, steps==maxSteps)

# Imputing missing values

## Calculate and report the total number of missing values in the dataset 
## (i.e. the total number of rows with NAs)

length(missingvalues)

##  Devise a strategy for filling in all of the missing values in the dataset. 
## The strategy does not need to be sophisticated. For example, you could use 
## the mean/median for that day, or the mean for that 5-minute interval, etc.
## & 
## Create a new dataset that is equal to the original dataset but with the 
## missing data filled in.


dfNA <- merge(x = dfNA, y = steps_median_5minutes, by = "interval", all.x=TRUE)
df_new <- rbind(dfNA,dfNoNA)

## Make a histogram of the total number of steps taken each day and Calculate and 
## report the mean and median total number of steps taken per day. Do these values 
## differ from the estimates from the first part of the assignment? What is the 
## impact of imputing missing data on the estimates of the total daily number of steps?

steps_sum_day <- aggregate(df_new$steps, list(df_new$date), FUN=sum)
hist(steps_sum_day$x, breaks=30)
round(mean(steps_sum_day, na.rm=T))
round(median(steps_sum_day, na.rm=T))

# Are there differences in activity patterns between weekdays and weekends?

## 1. Create a new factor variable in the dataset with two levels -- "weekday"
## and "weekend" indicating whether a given date is a weekday or weekend day.

weekend <- c("Saturday", "Sunday")
weekday <- ifelse(weekdays(as.Date(df_new$date)) %in% weekend, 
               "weekend", "weekday")
df_new$weekday <- as.factor(weekday)

## 2. Make a panel plot containing a time series plot (i.e. type = "l") 
## of the 5-minute interval (x-axis) and the average number of steps taken, 
## averaged across all weekday days or weekend days (y-axis).

install.packages("reshape")
library(reshape)
mdf_new <- melt(df_new, id=c("interval","weekday"))


library(lattice)
xyplot(df_new$steps~df_new$interval|df_new$weekday, type="l")