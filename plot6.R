library(dplyr)

NEI <- readRDS("./exdata_data_NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata_data_NEI_data/Source_Classification_Code.rds")

########################## Question 6 ####################################
mv_la <- subset(NEI, fips == '06037')
mv_balt <- subset(NEI, fips == '24510')

mv_eis <- with(SCC, grep('Vehicle', EI.Sector))
mv_scc <- SCC[mv_eis,]$SCC

mv_balt <- subset(mv_balt, SCC %in% mv_scc)
mv_la <- subset(mv_la, SCC %in% mv_scc)

mv_balt_by_year <- mv_balt %>% group_by(year) %>% 
  summarise(Emissions = sum(Emissions), .groups = 'drop')
mv_balt_by_year$year <- as.character(mv_balt_by_year$year)

mv_la_by_year <- mv_la %>% group_by(year) %>% 
  summarise(Emissions = sum(Emissions), .groups = 'drop')
mv_la_by_year$year <- as.character(mv_la_by_year$year)

png('plot6.png')

par(mar = c(5, 4, 4, 5))
plot(mv_la_by_year$year, mv_la_by_year$Emissions, 
     xlab = 'Year', ylab = 'LA: Motor Vehicle Emissions', xaxt = 'n',
     yaxs = 'r',
     type = 'p', pch = 16, cex = 2)
title(main = 'PM2.5 Emissions Due To Motor Vehicles In L.A. & Baltimore, In Each Of 4 Years')
axis(1, c('1999', '2002', '2005', '2008'))

par(new = TRUE)
plot(mv_balt_by_year$year, mv_balt_by_year$Emissions,
     pch = 1, cex = 2, col = 'blue',
     axes = FALSE, xlab = '', ylab = '')
par(new = TRUE)
plot(mv_balt_by_year$year, mv_balt_by_year$Emissions,
     pch = 1, cex = 1, col = 'blue',
     axes = FALSE, xlab = '', ylab = '')
axis(side = 4, at = pretty(mv_balt_by_year$Emissions), 
     yaxs = 'r', col = 'blue', col.axis = 'blue')
mtext('Baltimore: Motore Vehicle Emissions', side = 4, line = 3, col = 'blue')

dev.off()