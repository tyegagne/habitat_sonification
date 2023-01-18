# Required Packages
install.packages('seewave','tuneR','audio','raster')
library(seewave)
library(tuneR)
library(audio)
library(dplyr)
library(raster)
library(ggplot)

# Functions

# Scale Function
range01 <- function(x, ...){(x - min(x, ...)) / (max(x, ...) - min(x, ...))}

############## Audio Player Set
setWavPlayer("audacious")
##########

# Spiral Parameterization
pi = 3.1415926535
vertspacing = 10   # Leave it alone
thetamax = 20 * pi # how many times the spiral spirals

# underlying spiral = uneven point spacing blueprint
b = vertspacing/2/pi
theta = seq(from = 0, to = thetamax, by = 0.001)
x = b*theta*cos(theta)
y = b*theta*sin(theta)

# Calculate equidistant points
horzspacing = .1 # how many points on the equidistant spiral 
smax = 0.5*b*thetamax*thetamax
s = seq(from = 0, to = smax, by = horzspacing)
length(s)
thetai = sqrt(2*s/b)
xi = b*thetai*cos(thetai)
yi = b*thetai*sin(thetai)

plot(xi,yi, cex = .1)

point_df <- data.frame( x = xi, y = yi)
# Scale the x y space to 0 - 1
point_df$x <- range01(point_df$x)
point_df$y <- range01(point_df$y)

#  read in dem
str_name<-'/Users/tyler.gagne/Desktop/habitat_sonification/dems/rr201404_029_lagoon02_dem.tif' 
imported_raster=raster(str_name)
df_convert <- raster::as.data.frame(imported_raster,xy=TRUE)

# scale x y space to 0 - 1
df_convert$x <- range01(df_convert$x)
df_convert$y <- range01(df_convert$y)
# Convert first two columns as spatial x-y       
df_convert <- rasterFromXYZ(df_convert)  

# take a look
plot(df_convert)
points(point_df$x,point_df$y, pch=0, cex = .01 )

# Convert spiral to x y spatial points
centroid_spdf <- SpatialPointsDataFrame(
  point_df[,1:2], proj4string=df_convert@crs, point_df)

# Extract DEM values at spiral points
cent_max <- raster::extract(df_convert,             # raster layer
                            centroid_spdf,   # SPDF with centroids for buffer
                            buffer = .01,     # buffer size, units depend on CRS
                            fun=mean,         # what to value to extract
                            df=TRUE)         # return a dataframe? 

# Turn back to vector
sound_vec <- as.data.frame(cent_max)

# drop outside spiral NA points
sound_vec <- na.omit(sound_vec)

# scale vec to 0 - 1 
sound_vec$rr201404_029_lagoon02_dem <- range01(sound_vec$rr201404_029_lagoon02_dem)

# create audio sample out of vector
testy <- audioSample(sound_vec$rr201404_029_lagoon02_dem, bits = 16)
str(testy)
plot(testy, type = 'l')
play(testy)
savewav(testy) # Saves to working directory as .wav file named same as object




