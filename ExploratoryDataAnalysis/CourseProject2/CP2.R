library(dplyr)
library(ggplot2)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Create plot1
#Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
yearly_emission<-NEI %>% group_by(year) %>% summarise(sum(Emissions))
png(filename="plot1.png",height=480,width=480,unit="px")
plot(yearly_emission,type="l",ylab="Total Emission",main="PM2.5 emission across USA")
dev.off()
#YES, total emissions have decreased

#Create plot2
#Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot answering this question.
Baltimore_yearly_emission<- NEI %>% filter(fips == "24510") %>% group_by(year) %>% summarise(sum(Emissions))
png(filename="plot2.png",height=480,width=480,unit="px")
plot(Baltimore_yearly_emission,type="l",ylab="Total emission",main="Baltimore emission")
dev.off()

#Create plot3
#Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City? Which have seen increases in emissions from 1999-2008? Use the ggplot2 plotting system to make a plot answer this question.
Baltimore_emission_type<- NEI %>% filter(fips == "24510") %>% group_by(year,type) %>% summarise(Emission=sum(Emissions))
png(filename="plot3.png",height=480,width=640,unit="px")
g<-ggplot(Baltimore_emission_type,aes(year,Emission))+geom_line()+facet_grid(.~type)+ggtitle("Baltimore Emission by Type of Source")
print(g)
#qplot(year,Emission,data=Baltimore_emission_type,facets=.~type,main="Baltimore Emission by Type",geom="line")
dev.off()

#Create plot4:
#Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?
SCC_Coal<-SCC$SCC[grep("Coal",SCC$EI.Sector)] #Select SCC for coal relate sources
Coal_emission<-NEI[NEI$SCC %in% SCC_Coal,]%>% group_by(year) %>% summarise(Emission=(sum(Emissions))) #Select emissions for SCC in the codes selected above
png(filename="plot4.png",height=480,width=480,unit="px")
plot(Coal_emission,type="l",main="Coal Related emission across USA")
dev.off()

#Create plot5:How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?
SCC_motor_vehicle<-SCC$SCC[grep("Vehicles",SCC$EI.Sector)]
Baltimore_Vehicle_emission<-NEI[NEI$SCC %in% SCC_motor_vehicle,]%>% filter(fips=="24510") %>% group_by(year) %>% summarise(Emission=(sum(Emissions)))
png(filename="plot5.png",height=480,width=480,unit="px")
plot(Baltimore_Vehicle_emission,type="l",main="Motor Vehicle Related emission in Baltimore")
dev.off()

#Create plot6:Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?
LA_Vehicle_emission<-NEI[NEI$SCC %in% SCC_motor_vehicle,]%>% filter(fips=="06037") %>% group_by(year) %>% summarise(Emission=(sum(Emissions)))
png(filename="plot6.png",height=480,width=640,unit="px")
par(mfrow = c(1,2))
plot(Emission~year,LA_Vehicle_emission,type="l",col="Red",main="LA vehicle emissions")
plot(Emission~year,Baltimore_Vehicle_emission,type="l",col="Blue",main="Baltimore vehicle Emissions")
dev.off()
