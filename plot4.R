library(dplyr)
library(stringr)

NEI <- readRDS("./exdata_data_NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata_data_NEI_data/Source_Classification_Code.rds")

########################## Question 4 ####################################
coal_scc <- filter(SCC, str_detect(toupper(Short.Name), "COAL"))$SCC
coal_NEI <- subset(NEI, SCC %in% coal_scc)

coal_by_year <- coal_NEI %>% group_by(year) %>% 
  summarise(Emissions = sum(Emissions), .groups = 'drop')
coal_by_year$year <- as.character(coal_by_year$year)

png('plot4.png')

plot(coal_by_year$year, coal_by_year$Emissions, 
     xlab = 'Year', xaxt = 'n',
     ylab = 'Coal Emissions', yaxs = 'r',
     type = 'p', pch = 16, cex = 2)
title(main = 'Total PM2.5 Emissions Due To Coal In Each Of 4 Years')
axis(1, c('1999', '2002', '2005', '2008'))

dev.off()