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

#Create Plot3
png(filename="plot3.png",width=480,height = 480,units = "px")
plot(data$Time,data$Sub_metering_1,xlab="",ylab="Energy sub Metering",col="Black",type="l")
lines(data$Time,data$Sub_metering_2,col="Red",type="l")
lines(data$Time,data$Sub_metering_3,col="Blue",type="l")
legend("topright",names(data[7:9]),lty=1,col=c("Black","Red","Blue"))
dev.off()
