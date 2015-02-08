#plotting midpoints of splines in ggplot for one individual speaks using AAA exported caretesian coordinates

library(reshape2) # for melting and casting data
library(ggplot2) # for nice graphs

#imac
splines <- read.delim("/Users/Danielle/Dropbox/Ultrasound/coords/splines_MP.txt", na.strings = "*")
#AAA has an asterisk for NAs

#first convert data from wide to long with met and cast
splines <- cbind(ID = 1:nrow(splines), splines)  #puts an ID tag on each row before melt&cast
splines.m <- melt(splines, id = 1:7) #melts down all variables before fan co-ords
splines.m <- cbind(splines.m, colsplit(splines.m$variable, "_", names = c("Axis", "Fan"))) 
#splits the new variable column into separate measurements for axis and fan

splines.c <- dcast(splines.m, ID + Name  + Sequence+ Context +  Prompt + SampleTime + Duration + Fan ~ Axis)
#Casts the data into its final format :D


ggplot(splines.c, aes(x=x, y=y, colour=Context)) + stat_smooth(size=1)

#I also like to remove all the background crap for a clean image, although 
#WARNING the images are usually not to scale so removing axis values can be unadvisable sometimes
# so pick and choose what you wanna blank to fit this:

blank <-theme(axis.title.x = element_blank(), axis.title.y = element_blank(), legend.title=element_blank(), plot.background = 
    element_blank(),panel.grid.major = element_blank(),
		panel.grid.minor = element_blank(),panel.border = element_blank(),
		panel.background = element_blank(), axis.ticks = element_blank(), 
		axis.text.x = element_blank(), axis.text.y = element_blank())
		
ggplot(splines.c, aes(x=x, y=y, colour=Context)) + stat_smooth(size=1) + blank #plot with blank background
