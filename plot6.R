library(dplyr)

NEI <- readRDS("./exdata_data_NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata_data_NEI_data/Source_Classification_Code.rds")

########################## Question 6 ####################################
# The word 'vehicle' shows up in columns 'EI.Sector', 'SCC.Level.Two', 
# 'SCC.Level.Three', 'SCC.Level.Four'. I take the union of the four 
# sets of SCC values to indicate emissions caused by motor vehivles
l1 <- data.frame(SCC[with(SCC, grep('vehicle', EI.Sector, ignore.case = TRUE)),'SCC'])
l2 <- data.frame(SCC[with(SCC, grep('vehicle', SCC.Level.Two, ignore.case = TRUE)),'SCC'])
l3 <- data.frame(SCC[with(SCC, grep('vehicle', SCC.Level.Three, ignore.case = TRUE)),'SCC'])
l4 <- data.frame(SCC[with(SCC, grep('vehicle', SCC.Level.Four, ignore.case = TRUE)),'SCC'])
names(l1) <- 'SCC'
names(l2) <- 'SCC'
names(l3) <- 'SCC'
names(l4) <- 'SCC'

mv_scc <- rbind(rbind(rbind(l1, l2), l3), l4)
mv_scc <- unique(mv_scc$SCC)

rm(l1, l2, l3, l4)
#===================================================================
mv_balt <- subset(NEI, fips == '24510')
mv_la <- subset(NEI, fips == '06037')

mv_balt <- subset(mv_balt, SCC %in% mv_scc)
mv_la <- subset(mv_la, SCC %in% mv_scc)

mv_balt <- aggregate(Emissions ~ year, mv_balt, sum)
mv_balt <- mv_balt[, c('year','Emissions')]
mv_balt$year <- as.numeric(mv_balt$year)

mv_la <- aggregate(Emissions ~ year, mv_la, sum)
mv_la <- mv_la[, c('year','Emissions')]
mv_la$year <- as.numeric(mv_la$year)

png('plot6.png')
#==============================================================
plot.new()
title(main = expression('PM'[2.5]*' Emissions Due To Motor Vehicles In L.A. & Baltimore, In Each Of 4 Years'))

par(mar = c(5, 4, 4, 5))
plot(mv_la$year, mv_la$Emissions, 
     xlab = 'Year', ylab = 'LA: Motor Vehicle Emissions', xaxt = 'n',
     yaxs = 'r',
     type = 'p', pch = 16, cex = 2)
par(new = TRUE)
plot(mv_balt$year, mv_balt$Emissions,
     pch = 1, cex = 2, col = 'blue',
     axes = FALSE, xlab = '', ylab = '')
par(new = TRUE)
plot(mv_balt$year, mv_balt$Emissions,
     pch = 1, cex = 1, col = 'blue',
     axes = FALSE, xlab = '', ylab = '')
axis(side = 4, at = pretty(mv_balt$Emissions), 
     yaxs = 'r', col = 'blue', col.axis = 'blue')
axis(1, c('1999', '2002', '2005', '2008'))
mtext('Baltimore: Motore Vehicle Emissions', side = 4, line = 3, col = 'blue')
par(new = TRUE)
#==============================================================
dev.off()