library(dplyr)

NEI <- readRDS("./exdata_data_NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata_data_NEI_data/Source_Classification_Code.rds")

########################## Question 5 ####################################
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

mv_balt <- subset(NEI, fips == '24510')
mv_balt <- subset(mv_balt, SCC %in% mv_scc)

mv_balt <- aggregate(Emissions ~ year, mv_balt, sum)
mv_balt$year <- as.numeric(mv_balt$year)

png('plot5.png')
#==============================================================
barplot(mv_balt$Emissions, names = mv_balt$year,
        xlab = 'Year',
        ylab = 'Emissions')

title(main = expression('Total PM'[2.5]*' Emissions Due to Vehicles For Baltimore For Each Of 4 Years'))
#==============================================================
dev.off()