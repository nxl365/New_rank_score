
##### analysis of all variables for 3 impact group with uneven classes sample size (HIGH,LOW,MODIFIER )
### Rainclouds plot, Welch's t-test



library(ggplot2)
library("tidyr")
library(ggpubr)
library(dplyr)




#### data: a example `df_1` from HIGH impact group
df_1 <- read.table('/Users/nancy/Desktop/RS_projects/data/02_data_analysis/06_CSQ/04_impactHIGH_sub_1.csv', header = TRUE, sep=',') 



#### 0. box  plot 
#### refer:  https://r-graph-gallery.com/265-grouped-boxplot-with-ggplot2.html 

#### 1. Rainclouds plot: box + half violin 
#### refer: https://wellcomeopenresearch.org/articles/4-63  -- p10 
library(cowplot)
library(readr)
source("R_rainclouds.R")     # refer to a source downloaded : https://github.com/RainCloudPlots/RainCloudPlots/tree/master/tutorial_R
source("summarySE.R")



## modify the df: pivot_longer function to a suitble parttern
df_1_m <- df_1 %>% 
  pivot_longer(GERP.._NR:Consequence, names_to="var", values_to="val") %>% 
  as.data.frame()


## one box per variety
box1 <- ggplot(df_1_m, aes(x=var, y=val, fill=CLNSIG)) + 
  geom_flat_violin(aes(fill =CLNSIG),position = position_nudge(x = .1, y = 0), adjust = 1.5, trim = FALSE, alpha = .5, colour = NA)+
  geom_boxplot(aes(x = var, y = val, fill = CLNSIG),outlier.shape = NA, alpha = .5, width = .2, colour = "black")+
  facet_wrap(~var, scale='free')+

  theme(
    legend.position = "right",               # Position the legend at the bottom
    legend.text = element_text(size = 15),
    legend.title = element_text(size = 15),
    
    #axis.text.x = element_text(size = 15),   # Change text size for x-axis
    axis.text.x = element_blank(),            # remove x text on each facet plot
    axis.text.y = element_text(size = 15),    # Change text size for y-axis
    
    #axis.title.x = element_text(size = 20),  # Change axis title size for x-axis
    axis.title.x = element_blank(),           # remove x-axis title
    axis.title.y = element_text(size = 20),   # Change title size for y-axis
    
    strip.text = element_text(size = 15))   # Change facet title size  
              

box1






##### 1.1  for merge plot
#install.packages('patchwork')
library(patchwork)

### if there is `df_2`, make `df2_m`, and get box2 plot
box2 <- ggplot(df_2_m, aes(x=var, y=val, fill=CLNSIG)) + 
  geom_flat_violin(aes(fill =CLNSIG),position = position_nudge(x = .1, y = 0), adjust = 1.5, trim = FALSE, alpha = .5, colour = NA)+
  geom_boxplot(aes(x = var, y = val, fill = CLNSIG),outlier.shape = NA, alpha = .5, width = .2, colour = "black")+
  facet_wrap(~var, scale='free')+


### merge plot by patchwork
box1/box2  






#### 2. Welch's t-test: not paired, unequal variance

#### refer:  https://www.tutorialspoint.com/how-to-perform-paired-t-test-for-multiple-columns-in-r 
#### https://www.statology.org/interpret-t-test-results-in-r/ 


## df_1[-6]: remove the non-numeric column class-'CLNSIG' 
lapply(df_1[-6], function(x) t.test(x~df_1$CLNSIG, mu = 0, alternative = 'two.sided', paired = FALSE, var.equal = FALSE, conf.level = 0.95))

