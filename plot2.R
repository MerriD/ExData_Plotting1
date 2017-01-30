plot2 <- function (directory) {
    
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
    
    png(filename = "plot2.png",
        width = 480, height = 480)
    
    ## construct plot

    plot(powercons_dt$Date_time, powercons_dt$Global_active_power,
         type = "l", xlab = "",
         ylab = "Global Active Power (kilowatts)")
    
    ## close file device
    
    dev.off()

}
