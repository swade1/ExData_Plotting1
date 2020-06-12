library(sqldf)
library(datasets)
#query for just Feb 1-2, 2007
query_string <- "select * from file where Date = '2/2/2007' or Date = '1/2/2007'"

#read in only a subset of the over 2 million lines in this data set
f <- read.csv2.sql(file="household_power_consumption.txt",sql=query_string,eol="\n")

#set any unavailable fields to NA
f[f=="?"] <- NA

#convert date/time to POSIXct class
dates <- strptime(as.character(f$Date), "%d/%m/%Y")
times <- f$Time

#concatenate dates and times
x <- paste(dates,times)

#convert to POSIXct - maintains the timestamp with the date
y <- as.POSIXct(x)

#Add z as DateTime column
f$DateTime=y

#reoder columns with DateTime first
f <- f[c(10,3,4,5,6,7,8,9)]

#generate histogram
hist(f$Global_active_power,col="red",main="Global Active Power",xlab="Global Active Power (kilowatts)")

#copy plot to file
dev.copy(png, height=480, width=480, file="plot1.png") 
dev.off()

