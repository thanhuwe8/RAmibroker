library(available)
library(usethis)
library(roxygen2)
library(formatR)

use_github(protocol = "https", auth_token = "3625f17ff089f22a81c008ef276b631938f5286d")
use_package_doc()
use_readme_rmd()
use_vignette("RAmibroker-vignette")
use_description()
use_version()

use_data(dataset1)
use_data(tickerlist)
use_data(dataset2)

AAest <- ImportAmibrokerDF(dataset1, tickerlist)
colnames(AAest) <- c("Date", tickerlist)
write.csv(AAest, "AAest.csv")

ticker2 <- read.csv("/Users/thanhuwe8/Projects/R project/MVA_BL/Amibroker Export/TICKERNONA.csv",header=F, stringsAsFactors = F)
ticker2 <- as.vector(t(ticker2))


AAA2 <- ImportAmibrokerDF(dataset1, ticker2)
colnames(AAA2) <- c("Date",ticker2)
AAA2 <- AAA2[AAA2$Date>as.Date("2017-01-01"),]
AAA3 <- AAA2[AAA2$Date>as.Date("2018-01-01"),]


dataset1 <- read.table("data-raw/FULLDATA20132018.txt",
                       sep = ",", header=T)

head(dataset1)
colnames(dataset1) <- c("Ticker", "Date", "Open", "High", "Low", "Close", "Volume")
head(dataset1)
date <- as.POSIXct(dataset1$Date, tz="GMT", format="%m/%d/%Y")
dataset1$Date <- date
tickerlist <- read.csv("/Users/thanhuwe8/Projects/R project/MVA_BL/Amibroker Export/V8000TICKER.csv",
                       header=T, stringsAsFactors = F)
head(tickerlist)
tickerlist <- tickerlist[,1]
head(AAA3)

na.locf(AAA3, fromLast=T)
rownames(AAA3) <- 1:dim(AAA3)[1]
dataset2 <- AAA3


system.file("/data-raw", "FULLDATA20132018.txt", package="RAmibroker")
system.file("data-raw")

tickerlist2 <- ticker2
use_data(tickerlist2)
write.csv(tickerlist2, "data-raw/tickerlist2.csv")
