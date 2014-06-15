# Visualization of Worldcup 2014 player's date and place of birth
# Author: Jose Gonzalez | www.jose-gonzalez.org
# Data source: Kimono labs API http://www.kimonolabs.com/worldcup/

# Load data
require(RJSONIO)

json_file <- fromJSON(content="players.json",encoding="utf8")
json_file <- lapply(json_file, function(x) {
  x[sapply(x, is.null)] <- NA
  unlist(x)
})
data  <- do.call("rbind", json_file)
data  <- data.frame(data)
str(data)
names(data)

# Geo code data
#====

data$place  <- with(data, paste(birthCity,birthCountry, sep=", "))
head(data$place)
data$id <- c(as.factor(data$place))
length(unique(data$id)) # 536 unique places

# Use Google Maps API
# See http://www.jose-gonzalez.org/using-google-maps-api-r/
source("scripts/google_maps.R")

locations  <- ldply(unique(data$place), function(x) geoCode(x))
table(complete.cases(locations)) # 277 unique locations found maybe hitting api limit
names(locations)  <- c("lat","lon","location_type", "place")

# Alternative using bing maps
source("scripts/bing_maps.R")

# Merge geocoded data
mapData  <- merge(data, locations, by.x="place",by.y="name", all.x=T)
table(complete.cases(mapData$lat)) # 727 out of 736 players geo-coded 
mapData  <- mapData[!is.na(mapData$source),]

# 
names(mapData)
head(mapData)
write.csv(mapData[,c("nationality","birthDate","latitude","longitude","foot")],"cartodb.csv", row.names=F, fileEncoding="utf8")
table(mapData$foot,useNA="always")
