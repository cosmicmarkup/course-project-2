url  <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
file1 <- "./summarySCC_PM25.rds"
file2 <- "./Source_Classification_Code.rds"
zip  <- "./data.zip"

# Download the file if necessary
if (!file.exists(file1) && !file.exists(file2)) {
    download.file(url, destfile = zip)
    unzip(zip)
    file.remove(zip)
}

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

total <- aggregate(Emissions ~ year,NEI, sum)

png(file = "plot1.png", width = 480, height = 480, units = "px")
barplot((total$Emissions)/10^6, names.arg = total$year, xlab = "Year", ylab = "Emissions (10^6 tons)", main = "Total Emissions")

dev.off()