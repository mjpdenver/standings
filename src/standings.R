### standings #url
library(XML)
library(googleVis)

#full.url <- "http://espn.go.com/mlb/standings/_/date/20140531"
dtes<- seq( ISOdate(2014, 4,10),  ISOdate(2014, 5, 30) , by="day")
dts <- format(dtes, "%Y%m%d")
temp <- NULL

for(i in 1:length(dts)) {
  nms <- paste("http://espn.go.com/mlb/standings/_/date/", dts[i], sep = "" )
  x <- readHTMLTable(nms, colClasses="character")
  dat <- x[[1]]
  dat$date <- dts[i]  
  temp <- rbind(temp, dat)
}

orig <- temp
temp <- orig

nms <- c("team",    "W",    "L",  "PCT",   "GB",  "HOME",  "ROAD",   "RS",   "RA",
         "DIFF",    "STRK" , "date")

names(temp) <- nms

ii <- grepl("League", temp$team)
temp <- temp[!ii, ]

ii <- temp$team %in% c("EAST", "WEST", "CENTRAL")
temp <- temp[!ii, ]

dat <- temp 

for( i in c(2,3,4,5,8,9,10)){
  dat[,i ]<- as.numeric(as.character(dat[,i]))
}

dat$GB[is.na(dat$GB)] <- 0
subdat <- subset(dat, date == "20140521")
plot(subdat$PCT, subdat$DIFF)
text(subdat$PCT, subdat$DIFF, subdat$team)


library(googleVis)

dat$date <- as.Date(dat$date,format="%Y%m%d")
dat$ID <- 1:nrow(dat)

mm <- gvisMotionChart(data=dat, idvar="team", timevar="date", xvar="DIFF", yvar="PCT")

plot(mm)