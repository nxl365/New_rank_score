##### analysis of all variables for MODERATE impact group with even classes sample size 
### correlation, PCA, heatmap 



library(reshape2)
library(ggplot2)
library(ggfortify)
library(ggrepel)


df_1 <- read.table('/Users/nancy/Desktop/RS_projects/data/02_data_analysis/06_CSQ/04_impactMODERATE_sub_1.csv', header = TRUE, sep=',') 


## check nr
table(df_1$CLNSIG)

## if need, remove some columns -- nominal categorical variables
#df_1 <- subset(df_1, select = -c(BIOTYPE, ORIGIN))  # like: ORIGIN, BIOTYPE


## PCA: prcomp() function-- sample should be row, parameter should be column
## PCA result only contain numeric items
## so: remove non-numerical column (class), otherwise changeing all other variables to number
df_1_nu <- df_1[,-1] 
summary(df_nu)







#### 1. PCA
#### refer to: https://www.youtube.com/watch?v=0Jp4gsfOLMs&t=394s #########################
####           https://cran.r-project.org/web/packages/ggfortify/vignettes/plot_pca.html
####           https://cran.r-project.org/web/packages/ggfortify/ggfortify.pdf


#library(ggfortify)
#library(ggplot2)


###  do pca
pca1 <- prcomp(df_1_nu, center=TRUE, scale=TRUE)  ##scaled=True, normalized

### check pca structure
# summary(pca)  # check eigenvalue: accounts for variance
# pca           # pca$rotation--check eigenvector: loading/correlation coefficient ; number of PCs == number of parameters/variables
# pca$x         # check PC scores: PC for each samples

### check how much variation PC accounts for
# p_1<-plot(pca$x[,1],pca$x[,2])     #plots PC1 and PC2 in X, usually pick these 2
# p_1                                ##### in plot: dots are samples, not cluster clearly
 
# pca.var <- pca$sdev^2           # how much variation in the original data each principal component/PC accounts for
# pca.var.per <- round(pca.var/sum(pca.var)*100,1) # percentage of variation that each PC accounts for
# p_2 <- barplot(pca.var.per,main="how much percentage variation each PC accounts for", xlab='principal component',ylab = "Percent variation")
# p_2


### plot pca
### alpha: transparent
###  loadings.label.hjust=2,loadings.label.vjust=2,loadings.label.repel = T： for modifying overlap lables 
## pp_1 is what we used in report
pp_1 <- autoplot(pca1, data = df_1  , colour = 'CLNSIG',size = 0.7,alpha=0.4,
                 loadings = TRUE, loadings.colour = 'blue',
                 loadings.label = TRUE, loadings.label.size = 3.5, loadings.label.colour = 'black',
                 loadings.label.hjust=2,loadings.label.vjust=2.5,loadings.label.repel = T)+
                
                theme(  legend.position = "right",               # Position the legend 
                        legend.text = element_text(size = 15),   
                        legend.title = element_text(size = 15),
                        
                        axis.text.x = element_text(size = 15),   # x axis text 
                        axis.text.y = element_text(size = 15),   # y axis text
                        
                        axis.title.x = element_text(size = 20),  # x axis title
                        axis.title.y = element_text(size = 20)   # y axis title
                        
                        # axis.text.x = element_blank(),           # remove x text 
                        # axis.title.x = element_blank()           # remove x title
      
                                                           )


pp_1









#### 2. heatmap
#### refer: https://www.geeksforgeeks.org/how-to-create-correlation-heatmap-in-r/ ########
####         https://www.statology.org/correlation-heatmap-in-r/ #########



#library(reshape2)
#library(ggplot2)

### create a correlation matrix
corr_1 <- cor(df_1_nu)

### round to 2 decimal
corr_1 <- round(corr_1,2)

### reorder corr matrix
### using corr coefficient as distance metric
dist_1 <- as.dist((1-corr_1)/2)


### hierarchical clustering the dist matrix
hc_1 <- hclust(dist_1)
corr_1 <-corr_1[hc_1$order, hc_1$order]

### reduce the size of correlation matrix
melted_corr_1 <- melt(corr_1)


### plotting the correlation heatmap
p1<- ggplot(data = melted_corr_1, aes(x=Var1, y=Var2, fill=value)) +
  geom_tile()+
  geom_text(aes(Var2, Var1, label = value),color = "black", size = 3.5) +
  scale_fill_gradient2(low = "blue", high = "red",limit = c(-1,1), name="Correlation") +
  theme( legend.position = "right",               #  legend 
         legend.text = element_text(size = 15),
         legend.title = element_text(size = 15),
        
         axis.title.x = element_blank(),          # no x title
         axis.text.x = element_text(size = 15, angle = 45, vjust = 1, hjust = 1), # set x text
            
         axis.title.y = element_blank(),          # no y title
         axis.text.y = element_text(size = 15),   
        
         panel.background = element_blank())    # remove background


p1







##### 3.  Saved by SVG: ensure the clarity even when zoom in significantly.
#### after install `svglite`,    `ggsave()` will use `svglite` as the backend for SVG output by default

# install.packages('svglite')
# library(svglite) 


## save as `.svg` or `.png`, size maybe different, but both can ensure clarity, recommend `.png` With better compatibility 
ggsave("../../../result/02_data_analysis/06_CSQ/moderate_impact_pca.svg", plot = pp_1, width = 50, height = 30, units = "cm")
ggsave("../../../result/02_data_analysis/06_CSQ/moderate_impact_pca.png", plot = pp_1, width = 54, height = 30, units = "cm")



ggsave("../../../result/02_data_analysis/06_CSQ/moderate_impact_heatmap.svg", plot = p1, width = 60, height = 50, units = "cm")
ggsave("../../../result/02_data_analysis/06_CSQ/moderate_impact_heatmap.png", plot = p1, width = 63, height = 45, units = "cm")


