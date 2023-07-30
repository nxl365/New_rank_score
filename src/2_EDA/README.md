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
<img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/03/df_1.png"  width="550" height="150"> 

middle data frame `df_1_m`: <br>
<img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/03/df_m.png"  width="400" height="150"> 

### 1) Rainclouds plot: box + half violin
<img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/03/1.png" width="600" height="400"> <br>

### 2) Welch's t-test: not paired, unequal variance
<img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/03/2.png"  width="550" height="150"> 
