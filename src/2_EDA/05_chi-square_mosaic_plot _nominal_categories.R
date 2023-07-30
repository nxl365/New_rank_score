##### nominal categorical variables: ORIGIN BIOTYPE  ########

##### chi-square test of independence, mosaic plot





library(tidyverse)
library(patchwork)    # install.packages('patchwork')

library(vcd)   #install.packages('vcd')
library(ggstatsplot)
library(ggplot2)


## data: all variants
df_1 <- read.table('/Users/nancy/Desktop/RS_projects/data/02_data_analysis/06_CSQ/07_ALL_origin_biotype.csv', header = TRUE, sep=',') 




##### 1. chi-square test of independence #####
####### refer : https://www.youtube.com/watch?v=KubK6hgMbvg 
####    + masaic plot        https://statsandr.com/blog/chi-square-test-of-independence-in-r/


#####  for ORIGIN: be careful-- since some categories of ORIGIN have < 5 frequency, but we already merge them to make each category has more than 5 frequency
chi_origin1 <- chisq.test(table(df_1$CLNSIG,df_1$ORIGIN))
chi_origin1


## check frequency of each category of variable
chi_origin1$expected                                          ## if a category's smallest expected frequency < 5:  Chi-squared here approximation may be incorrect
# fis_origin <- fisher.test(table(df_1$CLNSIG,df_1$ORIGIN))   ## if this happened, maybe good to use fisher test;  but `ORINGIN` is not 2*2: not works 


##### 2. mosaic plots: 
# plot type 1:
mosaic(~ CLNSIG + ORIGIN,
       direction = c("v", "h"),
       data = df_1,
       shade = TRUE)

# plot type 1-2
mosaic(~ORIGIN+CLNSIG,
       direction = c("v", "h"),
       data = df_1,
       shade = TRUE)

#plot type 2
ggbarstats(
  data = df_1,
  y = CLNSIG,
  x = ORIGIN
) +
  labs(caption = NULL) # remove caption

#plot type 2-2
ggbarstats(
  data = df_1,
  x = CLNSIG,
  y = ORIGIN
) +
  labs(caption = NULL) # remove caption









#####  for BIOTYPE : work well, each category has more than 5 frequency
chi_biotype1 <- chisq.test(table(df_1$CLNSIG,df_1$BIOTYPE))
chi_biotype1

chi_biotype1$expected                                           ## smallest expected > 5 : chi_square is ok


#plot type 2-2: 
ggbarstats(
  data = df_1,
  x = CLNSIG,
  y = BIOTYPE
) +
  labs(caption = NULL) # remove caption




