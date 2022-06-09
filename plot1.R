library(dplyr)

NEI <- readRDS('./exdata_data_NEI_data/summarySCC_PM25.rds')
SCC <- readRDS('./exdata_data_NEI_data/Source_Classification_Code.rds')

########################## Question 1 ####################################
by_year <- aggregate(Emissions ~ year, NEI, sum)
by_year <- subset(by_year, select = c(year, Emissions))
by_year$year <- as.numeric(by_year$year)

png('plot1.png')
#==============================================================
barplot(by_year$Emissions, names = by_year$year,
        xlab = 'Year',
        ylab = 'Emissions')

title(main = expression('Total PM'[2.5]*' Emissions In Each Of 4 Years'))
#==============================================================
dev.off()
