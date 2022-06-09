library(dplyr)
library(stringr)

NEI <- readRDS("./exdata_data_NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata_data_NEI_data/Source_Classification_Code.rds")

########################## Question 4 ####################################
coal_scc <- filter(SCC, str_detect(toupper(Short.Name), "COAL"))$SCC
coal_NEI <- subset(NEI, SCC %in% coal_scc)

coal_by_year <- aggregate(Emissions ~ year, coal_NEI, sum)
coal_by_year$year <- as.numeric(coal_by_year$year)

png('plot4.png')
#==============================================================
barplot(coal_by_year$Emissions, names = coal_by_year$year,
        xlab = 'Year',
        ylab = 'Emissions')
title(main = expression('Total PM'[2.5]*' Emissions Due To Coal In Each Of 4 Years'))
#==============================================================
dev.off()