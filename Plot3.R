setwd("/users/jhrudey/Desktop/Courses/Datasciencecoursera")
if (!file.exists("Course4_asmnt1")) {
  dir.create("Course4_asmnt1")
}

dataset_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(dataset_url, "./Course4_asmnt1/power.zip")
unzip("./Course4_asmnt1/power.zip", exdir="./Course4_asmnt1")
datedownloaded <- date()
list.files("./Course4_asmnt1")

setwd("/users/jhrudey/Desktop/Courses/Datasciencecoursera/Course4_asmnt1")

#read only the data from 1/2/2007 to 2/2/2007 inclusive. 
#There is data for each minute of the data and there are 1440 minutes in a day.
#I found a way to read just the dates of interest from this link: 
#https://stackoverflow.com/questions/25932628/how-to-read-a-subset-of-large-dataset-in-r.

powerfile <-read.table("household_power_consumption.txt", 
                       sep = ";", col.names = c("Date","Time","Global_active_power",
                                                "Global_reactive_power","Voltage","Global_intensity","Sub_metering_1",
                                                "Sub_metering_2","Sub_metering_3"),
                       na.strings = "?",
                       skip = grep("31/1/2007;23:59:00",
                                   readLines("household_power_consumption.txt")),
                       nrows = 2880)
head(powerfile)
tail(powerfile)

#make a datetime variable.

powerfile$DateTime <- paste(powerfile$Date, powerfile$Time)
powerfile$DateTime <- as.POSIXct(strptime(powerfile$DateTime,"%d/%m/%Y %H:%M:%S"))

#format dates and times.

powerfile$Date <- as.Date(powerfile$Date,"%d/%m/%Y")
library(chron)
powerfile$Time <- as.POSIXct(strptime(powerfile$Time,"%H:%M:%S"))

#an extra step is required for time to remove date from the formatted Time variable.

powerfile$Time <- times(format(powerfile$Time, "%H:%M:%S"))

#plot 3.
#make a blank plot using the sub_metering_1 as the base scale.
plot(powerfile$Sub_metering_1 ~ powerfile$DateTime, type = "n",xlab = "", ylab = "Energy sub metering") 
#use the lines function to add the lines from the sub_metering 1,2 and 3.
lines(powerfile$Sub_metering_1 ~ powerfile$DateTime)
lines(powerfile$Sub_metering_2 ~ powerfile$DateTime, col = "Red")
lines(powerfile$Sub_metering_3 ~ powerfile$DateTime, col = "Blue")
#make a legend (note cex helps make the legend smaller).
legend("topright", legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),col=c("black","red", "blue"), cex = 0.6, lty=1)
dev.copy(png, file = "plot3.png", width = 480, height = 480)
dev.off()

