# LG model: A Rank Score Model of Variants Prioritization for Rare Disease

A supervised logistic regression (LG) model is built using publicly available ClinVar data and our in-house Justhusky and KI pathogenic dataset (CJP) with 12 features, incorporating an allele frequency (AF) filtering process to prioritize genetic rare disease variants, specifically SNVs/InDels. 

The LG model not only provides the hard binary class predictions (benign and pathogenic) but also assigns a score based on the predicted probabilities of the model ranging from 0 to 1. Currently, a threshold of 0.5 is used, if a score >= 0.5, the model classifies it as pathogenic; < 0.5, it's deemed benign. Scores near the 0.5 threshold (e.g., 0.55 or 0.49) reflect lower classification confidence. However, probabilities close to 0 (benign) or 1 (pathogenic) denote high model confidence in its prediction. The model has the potential to enhance the ranking of genetic rare-disease diagnostics at Clinical Genomics Stockholm and contribute to further advancements in rare disease research.

## Setup
1. Clone this repo
2. install a conda environment with the necessary dependencies
```
conda env create --name rank_score -f RS_env.yml
```

## Pipeline

1. get annotated `vcf.gz` file:
First, annotate the original `*.vcf.gz` file using the [MIP](https://github.com/Clinical-Genomics/MIP) (Mutation Identification Pipeline framework). Before doing so, ensure that the input `*.vcf.gz` file has the required `FORMAT` and `SAMPLE` columns. If needed, use the provided Python script [fixvcf.py](https://github.com/nxl365/New_rank_score/tree/main/src/1_fix_vcf) to add these necessary formats to the input file.

2. run the script:  
**help**
```
Please make sure all required parameters are given
Usage: python finalscript_LG4_12feats_CJP_AF_args.py <OPTIONS>

Required Parameters:
--in       <in_name>.vcf.gz, the input annotated file 
--cons     `variants_consequences.txt`, a list of consequences of variants given by the Ensembl Variant Effect Predictor 
           (VEP), https://asia.ensembl.org/info/genome/variation/prediction/predicted_data.html
--model    `LG3_12feats_CJP.joblib`, the fitted LG model 
--pre      `preprocessor3_12feats_CJP.joblib`, the fitted preprocessor
--info     <INFO_extracted>.csv, the extracted features/information from annotated <name>.vcf.gz
--out      <out_name>.vcf.gz, the final output file
```

**command for example**  
```
python finalscript_LG4_12feats_CJP_AF_args.py \
--in ./test_data/test_MIPannotated_part_clinvar_221113.vcf.gz \
--cons ./variants_consequences.txt \
--model ./LG_model/LG3_12feats_CJP.joblib \
--pre ./LG_model/preprocessor3_12feats_CJP.joblib \
--info test_clinvar_info.csv \
--out test_clinvar_out.vcf.gz
```

prepare your own input:  `--in`   
           for test, you can try the annotated `test_MIPannotated_part_clinvar_221113.vcf.gz`  or  `MIPannotated_KIpathogenic.vcf.gz`

you will get 2 outputs:  `--info , --out`  
           the extracted features `test_info.csv`  
           the final file with predictions and scores from LG model `test_out.vcf.gz`    

Other parameters are stored in this repo  





