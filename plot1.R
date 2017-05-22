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

# Convert dates using as.Date(). This helps to filter the data set.
data$Date <- as.Date(data$Date, format= "%d/%m/%Y")

# Read in only data from 2007-02-01 and 2007-02-02
dataSubset <-
	filter(
		data,
		between(Date, as.Date("2007-02-01"), as.Date("2007-02-02")))

# Plot a histogram to a png file
png("./plot1.png", width = 480, height = 480)
hist(dataSubset$Global_active_power, col="red", main="Global Active Power", xlab="Global Active Power (kilowatts)") 
dev.off()
