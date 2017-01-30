plot4 <- function (directory) {
    
## add libraries
    
    if (!require("readr")) {
        install.packages("readr")
        }
    if (!require("sqldf")) {
        install.packages("sqldf")
        }

## download and unzip files

    tempzip <- tempfile(tmpdir = directory)
    download.file('https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip', tempzip)

    unzip(tempzip)
    unlink(tempzip)

## read in required data
    message("Beginning file read...")
    
    powercons <- read.csv2.sql("./exdata-data-household_power_consumption/household_power_consumption.txt", 
                               sql = "select * from file where Date = '1/2/2007'
                               or Date = '2/2/2007'",
                               header = TRUE)
    
    powercons_dt <- cbind(strptime(paste(powercons$Date, powercons$Time), 
                                   format = "%d/%m/%Y %H:%M:%S"), powercons[,3:9])
    colnames(powercons_dt)[1] <- 'Date_time'
    
    ## open file device
    
    png(filename = "plot4.png",
        width = 480, height = 480)
    
    ## construct plots
    
    ## plot layout
    
    par(mfcol = c(2, 2))
    
    ## plot 1
    
    plot(powercons_dt$Date_time, powercons_dt$Global_active_power,
         type = "l", xlab = "",
         ylab = "Global Active Power")
    
    
    ## plot 2
    ## set up basic plot with sub_metering_1
    
    plot(powercons_dt$Date_time, powercons_dt$Sub_metering_1,
         type = "l", xlab = "",
         ylab = "Energy sub metering")
    
    ## add sub_metering_2 to plot
    
    lines(powercons_dt$Date_time, powercons_dt$Sub_metering_2,
         lty = 1, col = "red")
    
    ## add sub_metering_3 to plot
    
    lines(powercons_dt$Date_time, powercons_dt$Sub_metering_3,
          lty = 1, col = "blue")
    
    ## add legend to plot
    
    legend("topright", 
           legend = names(powercons_dt[6:8]),
           lty = c(1, 1, 1),
           col = c("black", "red", "blue"))
    
    ## plot 3
    
    plot(powercons_dt$Date_time, powercons_dt$Voltage,
         type = "l", xlab = "datetime",
         ylab = "Voltage")
    
    ## plot 4
    
    plot(powercons_dt$Date_time, powercons_dt$Global_reactive_power,
         type = "l", xlab = "datetime",
         ylab = "Global_reactive_power")

    
    ## close file device
    
    dev.off()

}
