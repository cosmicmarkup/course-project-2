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

baltimore <- NEI[NEI$fips=="24510",]

total_baltimore <- aggregate(Emissions ~ year, baltimore, sum)

png(file = "plot3.png", width = 480, height = 480, units = "px")

ggp <- ggplot(baltimore, aes(factor(year), Emissions, fill = type)) +
	geom_bar(stat = "identity") +
	theme_bw() +
	guides(fill = FALSE) +
	facet_grid(.~type, scales = "free", space = "free") +
	labs(x = "Year", y = expression("Total PM"[2.5]*" Emisisons")) +
	labs(title = expression("PM"[2.5]*" Emissions - Baltimore (1999-2008)"))

print(ggp)

dev.off()