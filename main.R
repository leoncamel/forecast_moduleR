
# forecast with R runtime

library(forecast)
library(moduleR)

rt <- ModuleRuntime()

mydata.df = read.csv(rt$Input$TimeSeries$Val, header = TRUE, stringsAsFactors = FALSE)

paramColumnName = rt$Param$column_name$Val

# frequency's type is "integer", so, we need not convert it
# We can use it directly
paramFreq = rt$Param$frequency$Val

# we shoule convert a string parameter to vector
paramStart = scan(text=rt$Param$start$Val)
paramEnd = scan(text=rt$Param$end$Val)

mydata.ts = ts(data=mydata.df[[paramColumnName]], frequency = paramFreq, start=paramStart, end=paramEnd)
mydata.fit <- arima(mydata.ts, order=c(1,0,1))
paramForecastCount = rt$Param$forecast_number$Val
mydata.forecast = forecast(mydata.fit, h=paramForecastCount)

# Plot
pdf(rt$Output$PlotPdf$Val)
plot(mydata.forecast)
dev.off()

outputForecastResultFile = rt$Output$Forecast$Val
write.csv(mydata.forecast, file=outputForecastResultFile)
