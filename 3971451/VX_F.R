# this is code for charting individual VIX futures contracts. You need to know the contract letter and year
# http://cfe.cboe.com/Publish/ScheduledTask/MktData/datahouse/CFE_Z12_VX.csv

library(quantmod)

mth <- LETTERS[c(6:9,11:12,14:15)]
yr <- 13
n <- 10 # number of periods for calculating historical volatility in the chart

url <- paste0("http://cfe.cboe.com/Publish/ScheduledTask/MktData/datahouse/CFE_",mth,yr,"_VX.csv")
x <- read.csv(url,header=FALSE, stringsAsFactors=F)
colnames(x) <- names(x)
x <- x[-1,]

x$"Trade Date" <- as.Date(x$'Trade Date', format='%m/%d/%Y')
x[,2:11] <- data.frame(sapply(x[,2:11],FUN=as.numeric),stringsAsFactors=F)
x <- xts(x[,2:11], order.by=x$"Trade Date", frequency='d')
chartSeries(x$Close, subset='last 3 months',theme=chartTheme("white"),name=paste0("VX",mth,yr," Futures"))
addTA(volatility(last(x$Close,'4 months'),n=n,calc="close",N=252),legend=paste0(n,"-day HV"))
last(volatility(last(x$Close,'4 months'),n=n,calc="close",N=252))
