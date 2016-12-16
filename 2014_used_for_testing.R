library(RCurl)
library(RJSONIO)
library(maps)
library(mapdata)
library (ggplot2)

data_nfl = read.csv ("2014.csv", header = TRUE)
View (data_nfl)


#Code from lab 10
construct.geocode.url <- function(address, return.call = "json", sensor = "false") {
  root <- "http://maps.google.com/maps/api/geocode/"
  u <- paste(root, return.call, "?address=", address, "&sensor=", sensor, sep = "")
  return(URLencode(u))
}
#Code from lab 10
gGeoCode <- function(address,verbose=FALSE) {
  if(verbose) cat(address,"\n")
  u <- construct.geocode.url(address)
  doc <- getURL(u)
  x <- fromJSON(doc,simplify = FALSE)
  if(x$status=="OK") {
    lat <- x$results[[1]]$geometry$location$lat
    lng <- x$results[[1]]$geometry$location$lng
    return(c(lat, lng))
  } else {
    return(c(NA,NA))
  }
}

#Insert GeoCodes
for (i in 1:32){
data_nfl$Longitude[i] = (gGeoCode (data_nfl$State[i])[1])
data_nfl$Latitude[i] = (gGeoCode (data_nfl$State[i])[2])
}

#Clean up NA values 
#Why I'm getting them I dont know. If code is re run, NA's appear in different entries and so cleaning below will not be complete
data_nfl$Latitude[13] = (gGeoCode ("Houstan, Texas, United States")[2])
data_nfl$Latitude[14] = (gGeoCode ("Indianapolis, Indiana, United States")[2])
data_nfl$Longitude[15] = (gGeoCode ("Jacksonville, Florida, United States")[1])
data_nfl$Latitude[15] = (gGeoCode ("Jacksonville, Florida, United States")[2])
data_nfl$Longitude[16] = (gGeoCode ("Kansas City, Kansas, United States")[1])
data_nfl$Latitude[16] = (gGeoCode ("Kansas City, Kansas, United States")[2])
data_nfl$Longitude[17] = (gGeoCode ("Miami, Florida, United States")[1])
data_nfl$Longitude[18] = (gGeoCode ("Minneapolis, Minnesota, United States")[1])
data_nfl$Latitude[18] = (gGeoCode ("Minneapolis, Minnesota, United States")[2])
data_nfl$Longitude[19] = (gGeoCode ("Boston, Massachusetts, United States")[1])
data_nfl$Latitude[26] = (gGeoCode ("San Diego, California, United States")[2])
data_nfl$Longitude[27] = (gGeoCode ("Santa Clara, California, United States")[1])
data_nfl$Latitude[27] = (gGeoCode ("Santa Clara, California, United States")[2])
data_nfl$Longitude[28] = (gGeoCode ("Seattle, Washington, United States")[1])
data_nfl$Latitude[28] = (gGeoCode ("Seattle, Washington, United States")[2])
data_nfl$Latitude[29] = (gGeoCode ("St. Louis, Missouri, United States")[2])
data_nfl$Longitude[30] = (gGeoCode ("Tampa Bay, Florida, United States")[1])
data_nfl$Latitude[30] = (gGeoCode ("Tampa Bay, Florida, United States")[2])

#Separate column and find the success rate
data_nfl$Points.after.Touchdown.Success = as.numeric (lapply(strsplit(as.character(data_nfl$Points.after.Touchdown), "\\/"), "[", 1))
data_nfl$Points.after.Touchdown.Attempt = as.numeric (lapply(strsplit(as.character(data_nfl$Points.after.Touchdown), "\\/"), "[", 2))
data_nfl = transform(data_nfl, Points.after.Touchdown.Rate = data_nfl$Points.after.Touchdown.Success / data_nfl$Points.after.Touchdown.Attempt)
data_nfl = data_nfl [,c(-19, -20)]
data_nfl = data_nfl [,c(-13)]

#Same for field goals
data_nfl$FieldGoal.Success = as.numeric (lapply(strsplit(as.character(data_nfl$Field.Goals), "\\/"), "[", 1))
data_nfl$FieldGoal.Attempt = as.numeric (lapply(strsplit(as.character(data_nfl$Field.Goals), "\\/"), "[", 2))
data_nfl = transform(data_nfl, FieldGoal.Rate = data_nfl$FieldGoal.Success / data_nfl$FieldGoal.Attempt)
data_nfl = data_nfl [,c(-13, -19, -20)]


data_nfl = read.csv ("2014.csv", header = TRUE)
View (data_nfl)




row.names(data_nfl) <- data_nfl$Team
data_nfl = data_nfl[order(data_nfl$Total.Points),]
data_heat = data_nfl [, c(15, 4:14, 18, 19)]
View (data_heat)
data_heat = data.matrix (data_heat)
data_heatmap <- heatmap(data_heat, Rowv=NA, Colv=NA, 
                        col = cm.colors(256), scale="column", margins=c(5,10))


map('state', fill = FALSE, col = "#cccccc",resolution=)
symbols(data_nfl$Longitude, data_nfl$Latitude, circles=data_nfl$Total.TD, add=TRUE, inches=0.15, bg="#93ceef", fg="#ffffff")



p2<- ggplot(data_nfl,aes(data_nfl$Total.TD,data_nfl$Passing.TD))
p2+geom_point(aes(alpha=Safeties))+geom_smooth()+labs(x="Total TD",y="Passing TD")

d <- data_nfl[,sapply(data_nfl,is.integer)|sapply(data_nfl,is.numeric)] 
d = data_nfl [, 4:12, 14:15]
View (d)
cor <- as.data.frame(round(cor(d), 6))
cor <- cbind(Variables = rownames(cor), cor)
#gvisTable(cor) 
View (cor)



View (data_nfl)
write.csv(data_nfl, "C:/Users/Conor/Desktop/College/DT265/Semester_Two/3. Data Visualisation/Assignment 3/Conor.Reid/Data/2014.csv") 