library(ggplot2)

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

vehicles <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE)
vehicles_SCC <- SCC[vehicles,]$SCC
vehicles_NEI <- NEI[NEI$SCC %in% vehicles_SCC,]

bvehicles_NEI <- vehicles_NEI[vehicles_NEI$fips=="24510",]

png(file = "plot5.png", width = 480, height = 480, units = "px")

ggp <- ggplot(bvehicles_NEI,aes(factor(year),Emissions)) +
	geom_bar(stat = "identity", fill = "green", width = 0.75) +
	theme_bw() +  guides(fill = FALSE) +
	labs(x = "Year", y = expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
	labs(title = expression("PM"[2.5]*" Motor Vehicle Emissions - Baltimore (1999-2008)"))

print(ggp)

dev.off()