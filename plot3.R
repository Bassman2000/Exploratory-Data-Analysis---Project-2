library(dplyr)
library(ggplot2)

NEI <- readRDS("./exdata_data_NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata_data_NEI_data/Source_Classification_Code.rds")

########################## Question 3 ####################################
balt <- subset(NEI, fips == '24510')
balt <- balt %>% group_by(year, type) %>% summarise(Emissions = sum(Emissions), .groups = "keep")
balt$year <- as.character(balt$year)

plt <- ggplot(data = balt, aes(year, Emissions)) +
  geom_point(color = 'blue', size = 1) +
  labs (title = 'PM2.5 Emissions For Baltimore by Source Type',
        y = 'Emissions')
plt <- plt + facet_grid(. ~ factor(balt$type,levels=c("ON-ROAD","NON-ROAD","POINT", "NONPOINT")))

ggsave('plot3.png', device = 'png' ,plt)