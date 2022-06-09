library(dplyr)
library(ggplot2)

NEI <- readRDS("./exdata_data_NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata_data_NEI_data/Source_Classification_Code.rds")

########################## Question 3 ####################################
balt <- subset(NEI, fips == '24510')
balt <- aggregate(Emissions ~ year + type, balt, sum)
balt$year <- as.numeric(balt$year)

#==============================================================
plt <- ggplot(data = balt, aes(factor(year), Emissions)) +
  geom_bar(stat = 'identity') +
  labs (title = expression('PM'[2.5]*' Emissions For Baltimore by Source Type'),
        y = 'Emissions', x = 'Year') +
  theme(axis.text.x = element_text(angle = -70))

plt <- plt + facet_grid(. ~ factor(balt$type,levels=c("ON-ROAD","NON-ROAD","POINT", "NONPOINT")))
#==============================================================
ggsave('plot3.png', device = 'png' ,plt)