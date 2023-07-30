## density histogram, scatter and marginal
## use 2 variables: RankScore vs CADD



#install.packages("tidyverse")  # ggplot2,tidyr
#install.packages("ggpubr")     # ggpubr
#install.packages("ggExtra")    # ggExtra

library(ggplot2)
library("tidyr")
library(ggpubr)
library(ggExtra)


#### df: cadd rankscore clinsig(classify) , 2 classes (benign pathogenic),  remove none ######

df <- read.table('/Users/nancy/Desktop/RS_projects/data/02_data_analysis/01_cadd_rankscore_clnsig/03_cadd_rankscore_clnsig_2class_rmnan.csv', header = TRUE, sep=',') 

## check structure
clnsig_categories <- unique(df$CLNSIG)
length(clnsig_categories)
table(df$CLNSIG) # number of each calss





#### 1.  density histogram: a entire distribution for each variable ; y-density, x-variable value;  sum(y * x)=1  ##########
#### refer: https://r-charts.com/distribution/histogram-density-ggplot2/?utm_content=cmp-true
# library(ggplot2)
# library("tidyr")

df2 <- data.frame(CADD=df$CADD,RankScore=df$RankScore) # df2: only include CADD , RankScore columns
df3 <- df2 %>%                                         # Apply pivot_longer function:gather to key pairs
  pivot_longer(colnames(df2)) %>% 
  as.data.frame()


## plot
ggp1 <- ggplot(df3, aes(x = value)) +    
  geom_histogram(aes(y = ..density..), colour=1, fill="white") + 
  geom_density(lwd=1,col = 4, fill=4, alpha=0.25)+
  facet_wrap(~ name, scales = "free")
ggp1





#### 2.  density histogram: for each variable, show a distribution of each class 
## CADD 
df4 <- data.frame(CADD=df$CADD, CLNSIG=df$CLNSIG)
df_4 <- df4 %>% gather(-CLNSIG, key = "cadd", value = "value")

ggp_cadd_iden <- ggplot(df_4, aes(x = value)) +    # Draw histogram & density
  geom_histogram(aes(y = ..density..), colour=1, fill="white") + 
  geom_density(lwd=1,col = 4, fill=4, alpha=0.25) + 
  facet_wrap(~CLNSIG, scales = "free")+
  xlab("CADD value")
ggp_cadd_iden

ggsave("cadd_density.jpeg", ggp_cadd_iden, width = 15, height = 5, dpi = 300)  # save


## Rankscore 
df5 <- data.frame(RankScore=df$RankScore, CLNSIG=df$CLNSIG)
df_5 <- df5 %>% gather(-CLNSIG, key = "rankscore", value = "value")

ggp_rankscore_iden <- ggplot(df_5, aes(x = value)) +    # Draw histogram & density
  geom_histogram(aes(y = ..density..), colour=1, fill="white") + 
  geom_density(lwd=1,col = 5, fill=4, alpha=0.25) + 
  facet_wrap(~CLNSIG, scales = "free") +
  xlab("RankScore value")
ggp_rankscore_iden

ggsave("rankscore_density.jpeg", ggp_rankscore_iden, width = 15, height = 5, dpi = 300) # save





#### 3. scatter plot: CADD vs RankScore in each class 
#### refer: https://drsimonj.svbtle.com/plot-some-variables-against-many-others 

## just check the gather tidy function
df_t <- df %>% gather(-RankScore, key = "cadd", value = "value")

## plot
# library(ggpubr)

ggp_cadd_rankscore_cor <- df %>%
  gather(-RankScore, -CLNSIG, key = "cadd", value = "value") %>%       #1st: gather to key pairs
  ggplot(aes(x = RankScore, y = value)) +
  geom_point() +
  stat_smooth() +
  facet_wrap(~ CLNSIG, scales = "free") +
  theme_bw()+
  stat_cor(method = "spearman", label.x = -8, label.y = 65)+
  xlab("RankScore") +
  ylab("CADD") 

ggp_cadd_rankscore_cor
#ggsave("cadd_rankscore-scatter.jpeg", ggp_cadd_rankscore_cor, width = 15, height = 5, dpi = 300)






#### 4. scatter + marginal plot: CADD vs RankScore for both 2 calsses + marginal plots of distribution

#library(ggExtra)

p <- ggplot(df,aes(x=RankScore,y=CADD,color=CLNSIG))+
  geom_point()+
  theme_bw()+
  theme(legend.position = "bottom")
  #geom_smooth()                       ## give smooth line

p_d <- ggMarginal(p, groupColour = TRUE,groupFill = TRUE)                   ## , add trend line;  + density plot.     by default, <type="density">; density + histogram: <type="densigram"> 
p_b <- ggMarginal(p, groupColour = TRUE,groupFill = TRUE, type="boxplot")   ## + box plot
p_v <- ggMarginal(p, groupColour = TRUE,groupFill = TRUE, type="violin")   ## + violin plot

p_d

#ggsave("/Users/nancy/Desktop/RS_projects/result/02_data_analysis/04_cadd_rankscore_2class_scatter_distri.jpeg", p_d, dpi=300)
#ggsave("cadd_rankscore-scatter_density_box.jpeg", p_b, dpi=600)
#ggsave("cadd_rankscore-scatter_density_violin.jpeg", p_v, dpi=600)