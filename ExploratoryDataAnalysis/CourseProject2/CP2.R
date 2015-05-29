library(dplyr)
library(ggplot2)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Create plot1:Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008
yearly_emission<-NEI %>% group_by(year) %>% summarise(sum(Emissions))
png(filename="plot1.png",height=480,width=480,unit="px")
plot(yearly_emission,type="l",ylab="Total Emission")
dev.off()
  #Yes emissions have decreased

#Create plot2:Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot answering this question.
Baltimore_emission<- NEI %>% filter(fips == "24510") %>% group_by(year) %>% summarise(sum(Emissions))
png(filename="plot2.png",height=480,width=480,unit="px")
plot(Baltimore_emission,type="l",ylab="Total emission",main="Baltimore emission")
dev.off()

#Create plot3:Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City? Which have seen increases in emissions from 1999-2008? Use the ggplot2 plotting system to make a plot answer this question.
Baltimore_emission_type<- NEI %>% filter(fips == "24510") %>% group_by(year,type) %>% summarise(Emission=sum(Emissions))
png(filename="plot3.png",height=480,width=480,unit="px")
#qplot(year,Emission,data=Baltimore_emission_type,facets=.~type,main="Baltimore Emission by Type",geom="line")
g<-ggplot(Baltimore_emission_type,aes(year,Emission))+geom_line()+facet_grid(type~.)+ggtitle("Baltimore Emission by Type")
print(g)
dev.off()

#Create plot4:Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?
SCC_Coal<-SCC$SCC[grep("Coal",SCC$EI.Sector)]
Coal_emission<-NEI[NEI$SCC %in% SCC_Coal,]%>% group_by(year) %>% summarise(Emission=(sum(Emissions)))
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
png(filename="plot6.png",height=480,width=480,unit="px")
plot(Emission~year,LA_Vehicle_emission,type="l",col="Red",main="Motor Vehicle Related emission in Baltimore and LA",ylim=c(min(Baltimore_Vehicle_emission$Emission),max(LA_Vehicle_emission$Emission)))
lines(Emission~year,Baltimore_Vehicle_emission,type="l",col="Blue")
dev.off()


