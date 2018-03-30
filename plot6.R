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

vehicles_BNEI <- vehicles_NEI[vehicles_NEI$fips=="24510",]
vehicles_BNEI$city <- "Baltimore City"

vehicles_LANEI <- vehicles_NEI[vehicles_NEI$fips=="06037",]
vehicles_LANEI$city <- "Los Angeles County"

combined_NEI <- rbind(vehicles_BNEI,vehicles_LANEI)

png(file = "plot6.png", width = 480, height = 480, units = "px")

ggp <- ggplot(combined_NEI, aes(x = factor(year), y = Emissions, fill = city)) +
	geom_bar(aes(fill = year), stat = "identity") +
	facet_grid(scales = "free", space = "free", .~city) +
	guides(fill = FALSE) + theme_bw() +
	labs(x = "Year", y = expression("Total PM"[2.5]*" Emission(Kilo-Tons)")) + 
	labs(title = expression("PM"[2.5]*" Motor Vehicle Emissions - Baltimore & LA (1999-2008)"))

print(ggp)

dev.off()