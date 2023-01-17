install.packages('seewave','tuneR','audio')

library(seewave)
library(tuneR)
library(audio)
library(dplyr)


##############

setWavPlayer("audacious")
testy <- audioSample(tan(1:8000/10), 8000)
testy <- audioSample(sin(1:8000/7), 8000)


str(testy)
plot(testy)

play(testy)
savewav(testy)

##########

#############


t <- seq(0, 50, by=0.1)
x = t*cos(t)
y = t*sin(t)
plot(x,y)

