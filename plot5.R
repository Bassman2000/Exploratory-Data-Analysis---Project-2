library(dplyr)

NEI <- readRDS("./exdata_data_NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata_data_NEI_data/Source_Classification_Code.rds")

########################## Question 5 ####################################
mv_balt <- subset(NEI, fips == '24510')

mv_eis <- with(SCC, grep('Vehicle', EI.Sector))
mv_scc <- SCC[mv_eis,]$SCC
mv_balt <- subset(mv_balt, SCC %in% mv_scc)

mv_balt_by_year <- mv_balt %>% group_by(year) %>% 
  summarise(Emissions = sum(Emissions), .groups = 'drop')
mv_balt_by_year$year <- as.character(mv_balt_by_year$year)

png('plot5.png')

plot(mv_balt_by_year$year, mv_balt_by_year$Emissions, 
     xlab = 'Year', xaxt = 'n',
     ylab = 'Motor Vehicle Emissions', yaxs = 'r',
     type = 'p', pch = 16, cex = 2)
title(main = 'PM2.5 Emissions Due To Motor Vehicles In Baltimore In Each Of 4 Years')
axis(1, c('1999', '2002', '2005', '2008'))

dev.off()