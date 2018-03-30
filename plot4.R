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

combustion_related <- grepl("comb", SCC$SCC.Level.One, ignore.case=TRUE)
coal_related <- grepl("coal", SCC$SCC.Level.Four, ignore.case=TRUE) 
coal_combustion <- (combustion_related & coal_related)
combustion_SCC <- SCC[coal_combustion,]$SCC
combustion_NEI <- NEI[NEI$SCC %in% combustion_SCC,]

png(file = "plot4.png", width = 480, height = 480, units = "px")

ggp <- ggplot(combustion_NEI, aes(factor(year), Emissions/10^5)) +
	geom_bar(stat="identity", fill="grey", width=0.75) +
	theme_bw() +  guides(fill=FALSE) +
	labs(x="Year", y=expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
	labs(title=expression("PM"[2.5]*" Coal Combustion Emissions in US (1999-2008)"))

print(ggp)

dev.off()