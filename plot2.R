library(dplyr)

NEI <- readRDS("./exdata_data_NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata_data_NEI_data/Source_Classification_Code.rds")

########################## Question 2 ####################################
balt <- subset(NEI, fips == '24510')
balt <- aggregate(Emissions ~ year, balt, sum)
balt$year <- as.numeric(balt$year)

png('plot2.png')
#==============================================================
barplot(balt$Emissions, names = balt$year, xlab = 'Year', ylab = 'Emissions')
title(main = expression('Total PM'[2.5]*' Emissions For Baltimore For Each Of 4 Years'))
#==============================================================
dev.off()