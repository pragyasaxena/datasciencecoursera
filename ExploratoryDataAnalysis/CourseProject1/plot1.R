#importing data
data<-read.table("household_power_consumption.txt",sep=";",nrows=50000,skip=50000,colClasses = "character")
colnames(data)<-c("Date","Time","GlobalActivePower","GlobalReactivePower","Voltage","GlobalIntensity","Sub_metering_1","Sub_metering_2","Sub_metering_3")

#Convert to date
data$Date<-strptime(data$Date,"%d/%m/%Y")
#Subset Data
data<-data[which(data$Date == '2007-02-01'| data$Date == '2007-02-02'),]
#Convert to numeric
for (i in 3:9){
  data[,i]<-as.numeric(data[,i])
}
#Convert time column
data$Time<-paste(data$Date,data$Time)
data$Time<-strptime(data$Time,"%Y-%m-%d %H:%M:%S")

#Create plot1
png(filename="plot1.png",width=480,height = 480,units = "px")
hist(data$GlobalActivePower,xlab = "Global Active Power(kilowatts)",main="Global Active Power",col="Red")
dev.off()

