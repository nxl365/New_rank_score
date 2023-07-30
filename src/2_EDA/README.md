# Introduction of each EDA code

## 01 
data frame `df`: <br>
<img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/01/df.png"  width="350" height="200"> 

data frame `df_t`: <br>
<img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/01/df_t.png"  width="350" height="200"> 

### 1. density histogram: a entire distribution for each variable
<img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/01/1.png" width="500" height="300">

### 2. density histogram: for each variable, show a distribution of each class
CADD: <br>
<img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/01/2-CADD.png" width="500" height="300"> <br>
RankScore: <br>
<img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/01/2-RankSore.png" width="500" height="300">

### 3. scatter plot: CADD vs RankScore in each class
<img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/01/3.png" width="500" height="300"> <br>
R: correlation coefficient; Pearson
  
- Spearman (better in this case)
- Pearson  (only for linear relationships)
- Kendall  (test the similarities in the ordering of data when it is ranked by quantities)

### 4. scatter + marginal plot
marginal plot: density <br>
<img src="https://github.com/nxl365/New_rank_score/blob/main/src/2_EDA/photo/01/4-density.png" width="500" height="400">
