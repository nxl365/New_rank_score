# Introduction of each EDA code

## 01 
original data frame `df`: <br>
<img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/01/df.png"  width="300" height="150"> 

middle data frame `df_t`: <br>
<img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/01/df_t.png"  width="300" height="150"> 

### 1) density histogram: an entire distribution for each variable
<img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/01/1.png" width="500" height="300">

### 2) density histogram: for each variable, show a distribution of each class
CADD: <br>
<img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/01/2-CADD.png" width="500" height="300"> <br>
RankScore: <br>
<img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/01/2-RankSore.png" width="500" height="300">

### 3) scatter plot: CADD vs RankScore in each class
<img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/01/3.png" width="500" height="300"> <br>
R: correlation coefficient; Pearson
  
- Spearman (better in this case)
- Pearson  (only for linear relationships)
- Kendall  (test the similarities in the ordering of data when it is ranked by quantities)

### 4) scatter + marginal plot
marginal plot: density <br>
<img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/01/4-density.png" width="450" height="350">


### 5) Spearman: non-linear correlation between CADD and RankScore
(rho = 0.72, p = 0): <br>
  rho = 0.72, which indicates a strong positive correlation between the two variables. <br>
  p = 0, which is less than 0.05, there is a significant correlation between the two variables



## 02
original data frame `df1`: <br>
<img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/02/df1.png"  width="550" height="150"> 

middle data frame `df1_new`: <br>
<img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/02/df1_new.png"  width="400" height="150"> 

### 1) multiple histograms from grouped data
<img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/02/1.png" width="600" height="400"> <br>

* y-axis in density histogram/barplot: 
```
R:    give meanings of different y-axis values (`count, count, density…`) in barplot

`y=..count..`  : frequency 

`y=..count../sum(..count..)` : relative frequency

`y=..ncount..` : having the highest bar be 1 and rescale rest to it

`y=..density..` : density curve (having the area of the bars sum to 1)
```
>> reference: **[Normalizing y-axis in histograms in R ggplot to proportion](https://stackoverflow.com/questions/11766856/normalizing-y-axis-in-histograms-in-r-ggplot-to-proportion)**


## 03
original data frame `df_1`: <br>
<img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/03/df_1.png"  width="650" height="150"> 

middle data frame `df_1_m`: <br>
<img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/03/df_m.png"  width="400" height="150"> 

### 1) Rainclouds plot: box + half violin
<img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/03/1.png" width="600" height="400"> <be>

### 1).1  merge plots by `patchwork` package
<img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/03/fig.1.high-2.jpeg" width="600" height="400"> <be>


### 2) Welch's t-test: not paired, unequal variance
<img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/03/2.png"  width="600" height="200"> 


## 04
original data frame `df_1`: <br>
<img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/04/df_1.png"  width="400" height="150"> 

### 1) PCA
<img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/04/1.png" width="600" height="400"> <br>

* eigenvector: correlated coefficient/loading show vector of parameter on the plot; give how much loading/relationship each parameter has on PC
* eigenvalue: how much variance the PCs account for original data
* PC score: correlation between PC vs samples.
  
```
pca <- prcomp(df,scale=TRUE)

summary(pca)   # check eigenvalue: accounts for variance of all original data
pca            # pca$rotation--check eigenvector: loading/correlation coefficient ; number of PCs == number of parameters/variables
               # correlation between PC vs parameter
pca$x          # check PC scores: correlation between PC  vs  samples
```


### 2) heatmap
<img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/04/2.png" width="600" height="400"> <br>


### 3) scalable vector graphics (SVG) 
outputting to SVG Vector files, make sure the plots' clarity even when zoom in a lot  
package `svglite`, check code



## 05
original data frame `df_1`: <br>
<img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/05/df_1.png"  width="300" height="150"> 

### 1) chi-square test of independence
**`ORIGIN`**:<br>
<img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/05/2-%20ori_chi-square.png"  width="300" height="100"> <br>
> * expected frequency of each category in the variable:<br>
>   if a category's smallest expected frequency < 5,  Chi-squared here approximation may be incorrect<br>
    ORIGIN--combined some categories of ORIGIN 
  <img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/05/2-%20ori_expected%20frequency.png"  width="700" height="150"> 
<br>
<br>

**`BIOTYPE`**:<br>
> * expected frequency<br>
  <img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/05/2-2%20bio_fre.png"  width="400" height="60"> <br>


### 2) mosaic plots: 
**type 1-1**
<img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/05/1-1.png" width="500" height="300">

**type 1-2**
<img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/05/1-2.png" width="500" height="300">

**type 2-1**
<img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/05/1-3.png" width="500" height="300">

**type 2-2**
<img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/05/1-4.png" width="500" height="300">


  
  








