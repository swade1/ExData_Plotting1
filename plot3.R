#install.packages("gsubfn")
#install.packages("proto")
#install.packages("RSQLite")

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

text =  c("Sub_metering_1","Sub_metering_2","Sub_metering_3")
strwidth(text)

#generate line graph for sub_metering_1
plot(f$DateTime,f$Sub_metering_1,ylab="Energy sub metering",type="l",xlab="",oma=5)

#add sub_metering_2 line
lines(f$DateTime,f$Sub_metering_2,type="l",xlab="", col="red")
#and sub_metering_3 line
lines(f$DateTime,f$Sub_metering_3,type="l",xlab="", col="blue")

# add legend
legend("topright", text.width = strwidth(text)[1]*1.25, lwd=1, col=c("black","red","blue"), legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),x.intersp=0.5)
#copy plot to file
dev.copy(png,height=480, width=480, file="plot3.png") 
dev.off()

