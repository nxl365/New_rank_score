# LG model: A Rank Score Model of Variants Prioritization for Rare Disease

A supervised logistic regression (LG) model is built using publicly available ClinVar data and our in-house Justhusky and KI pathogenic dataset (CJP) with 12 features, incorporating an allele frequency (AF) filtering process to prioritize genetic rare disease variants, specifically SNVs/InDels. 

The LG model not only provides the hard binary class predictions (benign and pathogenic) but also assigns a score based on the predicted probabilities of the model ranging from 0 to 1. Currently, a threshold of 0.5 is used, if a score >= 0.5, the model classifies it as pathogenic; < 0.5, it's deemed benign. Scores near the 0.5 threshold (e.g., 0.55 or 0.49) reflect lower classification confidence. However, probabilities close to 0 (benign) or 1 (pathogenic) denote high model confidence in its prediction. The model has the potential to enhance the ranking of genetic rare-disease diagnostics at Clinical Genomics Stockholm and contribute to further advancements in rare disease research.

## Getting started
1. Clone the repo
2. install a conda environment with the necessary dependencies
```
conda env create --name rank_score -f RS_env.yml
```
3. fix your MIP annotated VCF file
4. run model
```
python 03_script_12feats_LG_CJP_imbalance_trybash.py \
--in ./test_data/MIPannotated_KIpathogenic.vcf.gz \
--cons ./variants_consequences.txt \
--model ./LG_model/02_12feats_CJP5-5_LG.joblib \
--pre ./LG_model/02_12feats_CJP5-5_preprocessor.joblib \
--info ttt_info.csv \
--out ttt_out.vcf.gz
```

