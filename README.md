# A Rank Score Model of Variants Prioritization for Rare Disease: LG model

After conducting exploratory data analysis (EDA) to examine the variables' distribution, patterns, correlations, and measure the classification performance of variables. A logistic regression (LG) model is built using publicly available ClinVar data and our in-house Justhusky and KI pathogenic dataset (CJP) with 12 features, incorporating an allele frequency (AF) filtering process to prioritize genetic rare disease variants, specifically SNVs/InDels. 

The LG model assigns a binary class label (benign or pathogenic) and provides a score ranging from 0 to 1. Lower scores indicate benign variants, while higher scores indicate pathogenic variants. Currently, a threshold of 0.5 is used to classify the variants. It has the potential to enhance the ranking of genetic rare-disease diagnostics at Clinical Genomics Stockholm and contribute to further advancements in rare disease research.

