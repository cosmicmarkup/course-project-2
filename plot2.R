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

baltimore <- NEI[NEI$fips=="24510",]

total_baltimore <- aggregate(Emissions ~ year, baltimore, sum)

png(file = "plot2.png", width = 480, height = 480, units = "px")

barplot(total_baltimore$Emissions, names.arg=total_baltimore$year, xlab="Year", ylab="Emissions", main="Total Baltimore Emissions")

dev.off()