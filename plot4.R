# See if household_power_consumption.txt file is in work directory. If so, use
# is. If not, download the zip file and unpack.
print("Downloading data zip file")
dataURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
path <- basename(dataURL)

if(!file.exists(path)){
	download.file(dataURL, path)
}

print("Unzipping data")
unzip(path)

if (!file.exists("./household_power_consumption.txt")) {
	stop("./household_power_consumption.txt does not exist")
}

# Read in the data. Treat ? as the missing data indicator. 
data <-
	read.table(
		"./household_power_consumption.txt",
		sep=";",
		header = T,
		stringsAsFactors = F,
		na.strings="?")

# Add a new datetime column to data subset
data$thedatetime <- with(data, as.POSIXct(paste(Date, Time), format="%d/%m/%Y %H:%M:%S"))

# Convert dates using as.Date(). Helps to filter the data set.
data$Date <- as.Date(data$Date, format= "%d/%m/%Y")

# Read in only data from 2007-02-01 and 2007-02-02
dataSubset <-
	filter(
		data,
		between(Date, as.Date("2007-02-01"), as.Date("2007-02-02")))

# Open up the PNG device
png("./plot4.png", width = 480, height = 480)

# Setup for a 2x2 plot
par(mfrow=c(2,2))

# Plot 4.1
plot(dataSubset$Global_active_power ~ dataSubset$thedatetime, type="l", ylab="Global Active Power", xlab="")

# Plot 4.2
plot(dataSubset$Voltage ~ dataSubset$thedatetime, type="l", ylab="Voltage", xlab="datetime")

# Plot 4.3
plot(dataSubset$Sub_metering_1 ~ dataSubset$thedatetime, type="l", ylab="Energy sub metering", xlab="")
lines(dataSubset$Sub_metering_2 ~ dataSubset$thedatetime, type="l", col="red")
lines(dataSubset$Sub_metering_3 ~ dataSubset$thedatetime, type="l", col="blue")
legend("topright",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lty=c(1,1,1),col=c("black","red","blue"),box.lty=0)

# Plot 4.4
plot(dataSubset$Global_reactive_power ~ dataSubset$thedatetime, type="l", ylab="Global_reactive_power", xlab="datetime")

# Close file
dev.off()
