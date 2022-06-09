library(data.table)
library(dplyr)
library(ggplot2)
library(stringr)

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

########################## Question 2 ####################################
balt_by_year <- subset(NEI, fips == '24510')
balt_by_year <- balt_by_year %>% group_by(year) %>% summarise(Emissions = sum(Emissions))
balt_by_year$year <- as.character(balt_by_year$year)

plot(balt_by_year$year, balt_by_year$Emissions, 
     xlab = 'Year', xaxt = 'n', 
     ylab = 'Emissions', yaxs = 'r',
     type = 'p', pch = 16, cex = 2)
title(main = 'Total PM2.5 Emissions For Baltimore For Each Of 4 Years')
axis(1, c('1999', '2002', '2005', '2008'))

########################## Question 3 ####################################
balt <- subset(NEI, fips == '24510')
balt <- balt %>% group_by(year, type) %>% summarise(Emissions = sum(Emissions))
balt$year <- as.character(balt$year)

plt <- ggplot(data = balt, aes(year, Emissions)) +
  geom_point(color = 'blue', size = 1) +
  labs (title = 'PM2.5 Emissions For Baltimore by Source Type',
        y = 'Emissions')
plt + facet_grid(. ~ factor(balt$type,levels=c("ON-ROAD","NON-ROAD","POINT", "NONPOINT")))

########################## Question 4 ####################################
coal_scc <- str_trim(filter(SCC, str_detect(toupper(Short.Name), "COAL"))$SCC)
coal_NEI <- subset(NEI, str_trim(SCC) %in% coal_scc)

coal_by_year <- coal_NEI %>% group_by(year) %>% 
  summarise(Emissions = sum(Emissions), .groups = 'drop')
coal_by_year$year <- as.character(coal_by_year$year)

plot(coal_by_year$year, coal_by_year$Emissions, 
     xlab = 'Year', xaxt = 'n',
     ylab = 'Coal Emissions', yaxs = 'r',
     type = 'p', pch = 16, cex = 2)
title(main = 'Total PM2.5 Emissions Due To Coal In Each Of 4 Years')
axis(1, c('1999', '2002', '2005', '2008'))

########################## Question 5 ####################################
mv_balt <- subset(NEI, fips == '24510')

mv_eis <- with(SCC, grep('Vehicle', EI.Sector))
mv_scc <- SCC[mv_eis,]$SCC
mv_balt <- subset(mv_balt, SCC %in% mv_scc)

mv_balt_by_year <- mv_balt %>% group_by(year) %>% 
  summarise(Emissions = sum(Emissions), .groups = 'drop')
mv_balt_by_year$year <- as.character(mv_balt_by_year$year)

plot(mv_balt_by_year$year, mv_balt_by_year$Emissions, 
     xlab = 'Year', xaxt = 'n',
     ylab = 'Motor Vehicle Emissions', yaxs = 'r',
     type = 'p', pch = 16, cex = 2)
title(main = 'PM2.5 Emissions Due To Motor Vehicles In Baltimore In Each Of 4 Years')
axis(1, c('1999', '2002', '2005', '2008'))

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





