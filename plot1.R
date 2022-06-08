library(dplyr)

NEI <- readRDS("./exdata_data_NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata_data_NEI_data/Source_Classification_Code.rds")

########################## Question 1 ####################################
by_year <- NEI %>% group_by(year) %>% 
  summarise(Emissions = sum(Emissions), .groups = 'drop')
by_year$year <- as.character(by_year$year)

png('plot1.png')

plot(by_year$year, by_year$Emissions, 
     xlab = 'Year', xaxt = 'n',
     ylab = 'Emissions', yaxs = 'r',
     type = 'p', pch = 16, cex = 2)
title(main = 'Total PM2.5 Emissions In Each Of 4 Years')
axis(1, c('1999', '2002', '2005', '2008'))

dev.off()