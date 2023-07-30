######## histogram density plots of Rankscore overlap data for all INFO parameters##################

## refer: Normalizing y-axis in histograms in R ggplot to proportion https://stackoverflow.com/questions/11766856/normalizing-y-axis-in-histograms-in-r-ggplot-to-proportion;
##  multiple histograms from grouped data: https://r-graphics.org/recipe-distribution-multi-hist



library(ggplot2)
library("tidyr")
library(ggpubr)
library(dplyr)



## data: rankscore ovelap value 17-23 , here only one df example is shown
df1 <- read.table('/Users/nancy/Desktop/RS_projects/data/02_data_analysis/06_CSQ/02_mergePara_RKoverlap_1.csv', header = TRUE, sep=',') 

## check nr
table(df1$CLNSIG)



## modify df: pivot_longer function---for plotting each parameter separately in one figure
df1_new <- df1 %>%                          
  pivot_longer(CADD:MES.SWA_donor_ref_comp, names_to="var", values_to="val") %>% 
  as.data.frame()



## density histogram plot------ in one figure, multiple variables' histograms, y-axis: density is normalized to proportion
ggp1 <- 
  ggplot(df1_new, aes(x = val,fill=CLNSIG))+
  geom_histogram(aes(y = stat(count / sum(count))), alpha = 0.4) +     # in each bin: count/this bin's total count
  scale_y_continuous(labels = scales::percent_format()) + 
  facet_wrap(~factor(var,levels=c('CADD','RankScore','AF_ESP','AF_EXAC','AF_TGP','Frq',
                                  'GNOMADAF','GNOMADAF_popmax','Hom','ORIGIN','SWEGENAF',
                                  'Rk_allele_frequency','Rk_protein_prediction','Rk_gene_intolerance_prediction',
                                  'Rk_consequence','Rk_conservation','Rk_deleteriousness','Rk_splicing',"Consequence","IMPACT",
                                  "BIOTYPE","MES.NCSS_downstream_acceptor","MES.NCSS_downstream_donor","MES.NCSS_upstream_acceptor",
                                  "MES.NCSS_upstream_donor","MES.SWA_acceptor_alt","MES.SWA_acceptor_diff","MES.SWA_acceptor_ref",
                                  "MES.SWA_acceptor_ref_comp","MES.SWA_donor_alt","MES.SWA_donor_diff","MES.SWA_donor_ref",
                                  "MES.SWA_donor_ref_comp")), scales = 'free') +   # reorder the Facets in pannel
  xlab("value")+
  ylab("percentage of frequency")
  # ggtitle('Rankscore 17-23 overlap data histograms (subdata_1)')

ggp1



#ggsave('/Users/nancy/Desktop/RS_projects/result/02_data_analysis/06_CSQ/Rankscore 17-23 overlap data histograms (subdata_1).jpeg', ggp1,dpi=300)


