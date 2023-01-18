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

##attempt 3
pi = 3.1415926535
vertspacing = 10
horzspacing = 10
thetamax = 10 * pi
#underlying spiral
b = vertspacing/2/pi
theta = seq(from = 0, to = thetamax, by = 0.01)
#theta = 0:0.01:thetamax
x = b*theta*cos(theta)
y = b*theta*sin(theta)

plot(x,y)

#equidistant points
smax = 0.5*b*thetamax*thetamax
#s = 0:horzspacing:smax
s = seq(from = 0, to = smax, by = horzspacing)
thetai = sqrt(2*s/b)
xi = b*thetai*cos(thetai)
yi = b*thetai*sin(thetai)

plot(xi,yi)


#point_df$x <- range01(point_df$x)
#point_df$y <- range01(point_df$y)

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


library(signal)
#bf <- butter(3, 0.5)    # 10 Hz low-pass filter
#sound_vec$rr201404_029_lagoon02_dem <- filtfilt(bf,x = sound_vec$rr201404_029_lagoon02_dem)
sound_vec$rr201404_029_lagoon02_dem <- fft(sound_vec$rr201404_029_lagoon02_dem )


plot(sound_vec, type = 'l')


# sound




testy <- audioSample(sound_vec$rr201404_029_lagoon02_dem, bits = 16)



str(testy)
plot(testy)

play(testy)
savewav(testy)




