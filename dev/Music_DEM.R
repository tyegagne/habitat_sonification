install.packages('seewave','tuneR','audio','raster')

library(seewave)
library(tuneR)
library(audio)
library(dplyr)
library(raster)
library(ggplot)

range01 <- function(x, ...){(x - min(x, ...)) / (max(x, ...) - min(x, ...))}


##############

setWavPlayer("audacious")
testy <- audioSample(tan(1:8000/10), 8000)
testy <- audioSample(sin(1:8000/7), 8000)
testy <- audioSample(rnorm(1:8000/7), 8000)


str(testy)
plot(testy)

play(testy)
savewav(testy)

##########

#############


t <- seq(0, 50, by=0.001)
x = t*cos(t)
y = t*sin(t)
plot(x,y)
point_df <- data.frame(x,y)

point_df$x <- range01(point_df$x)
point_df$y <- range01(point_df$y)

plot(point_df$x, point_df$y)


#  read in dem



str_name<-'/Users/tyler.gagne/Desktop/habitat_sonification/dems/rr201404_029_lagoon02_dem.tif' 
imported_raster=raster(str_name)
plot(imported_raster)

df_convert <- raster::as.data.frame(imported_raster,xy=TRUE)

df_convert$x <- range01(df_convert$x)
df_convert$y <- range01(df_convert$y)

df_convert <- rasterFromXYZ(df_convert)  #Convert first two columns as lon-lat and third as value                
df_convert

plot(df_convert)

points(point_df$x,point_df$y, pch=0, cex = 2 )

# plot location of each tree measured
points(point_df$x,point_df$y, pch=19, cex=.5, col = 2)

centroid_spdf <- SpatialPointsDataFrame(
  point_df[,1:2], proj4string=df_convert@crs, point_df)

plot(df_convert)
plot(centroid_spdf,  add = T)

cent_max <- raster::extract(df_convert,             # raster layer
                            centroid_spdf,   # SPDF with centroids for buffer
                            buffer = .01,     # buffer size, units depend on CRS
                            fun=mean,         # what to value to extract
                            df=TRUE)         # return a dataframe? 

# view
sound_vec <- as.data.frame(cent_max)
sound_vec <- na.omit(sound_vec)

sound_vec$rr201404_029_lagoon02_dem <- range01(sound_vec$rr201404_029_lagoon02_dem)
str(sound_vec)

plot(sound_vec, type = 'l')


# sound
testy <- audioSample(sound_vec$rr201404_029_lagoon02_dem, bits = 8)



str(testy)
plot(testy)

play(testy)
#savewav(testy)




