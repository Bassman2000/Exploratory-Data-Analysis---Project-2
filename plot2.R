library(dplyr)

NEI <- readRDS("./exdata_data_NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata_data_NEI_data/Source_Classification_Code.rds")

########################## Question 2 ####################################
balt_by_year <- subset(NEI, fips == '24510')
balt_by_year <- balt_by_year %>% group_by(year) %>% summarise(Emissions = sum(Emissions))
balt_by_year$year <- as.character(balt_by_year$year)

png('plot2.png')

plot(balt_by_year$year, balt_by_year$Emissions, 
     xlab = 'Year', xaxt = 'n', 
     ylab = 'Emissions', yaxs = 'r',
     type = 'p', pch = 16, cex = 2)
title(main = 'Total PM2.5 Emissions For Baltimore For Each Of 4 Years')
axis(1, c('1999', '2002', '2005', '2008'))

dev.off()