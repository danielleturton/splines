## LOAD PACKAGES ####
library(tidyverse)

## LOAD DATA ####
data = read.delim("data.txt", na.strings = "*", strip.white = T) 



#first we need select the columns which contain only the coordinates you want to collapse
summary(data) 
# fans 39-42, 1-12 in the example have NAs so we can do PCA on them.  You can remove them manually or in dplyr like this:
data_pca_input = data %>%
  select_if(~ !any(is.na(.))) %>%
  select(-c(1:6)) # here I remove the first 6 columns with extra info in like context, speaker.  If you have more than 6 of these columns of info, adjust the number accordingly.  We just want fan points for the PCA.

data_pca = princomp(as.matrix(data_pca_input)) # running the PCA


summary(data_pca) #have a look at what the components are made of

plot(data_pca) #plot showing you how much of the variance is explained by the individual components
# Baayen (2008) PCs which account for less than 5% variance or have a clear discontinuity are probably not significant.  I write more on this here: 

biplot(data_pca) #biplot showing PC1 against PC2

# Following Baayen's recommendation, probably PC1 is the most important here at 74.7% (see Proportion of Variance of Comp.1 in the summary(data_pca output).  There is then a big drop to just 16.3% for PC2, and then 5.1% of PC3.  I'll keep PCs 1-3 for now and add them into my dataset.  The actual scores for the splines are stored in data_pca$scores

data_pca$scores # have a look

#create new dataset with the first three components (or however many you want) added to the original data frame

data_clean = data %>%
  mutate(PC1 = data_pca$scores[,1], # add first column of scores etc.
         PC2 = data_pca$scores[,2],
         PC3 = data_pca$scores[,3])

# you can now use these scores in boxplots etc. e.g. we can plot PCA against context for our speaker
ggplot(data_clean, aes(Context, PC1, colour = Context)) + geom_boxplot()

# See my ICPhS paper(Turton 2015) for more info:
# https://www.internationalphoneticassociation.org/icphs-proceedings/ICPhS2015/Papers/ICPHS0810.pdf