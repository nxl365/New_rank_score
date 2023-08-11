# LG model: A Rank Score Model of Variants Prioritization for Rare Disease

A supervised logistic regression (LG) model is built using publicly available ClinVar data and our in-house Justhusky and KI pathogenic dataset (CJP) with 12 features, incorporating an allele frequency (AF) filtering process to prioritize genetic rare disease variants, specifically SNVs/InDels. 

The LG model not only provides the hard binary class predictions (benign and pathogenic) but also assigns a score based on the predicted probabilities of the model ranging from 0 to 1. Currently, a threshold of 0.5 is used, if a score >= 0.5, the model classifies it as pathogenic; < 0.5, it's deemed benign. Scores near the 0.5 threshold (e.g., 0.55 or 0.49) reflect lower classification confidence. However, probabilities close to 0 (benign) or 1 (pathogenic) denote high model confidence in its prediction. The model has the potential to enhance the ranking of genetic rare-disease diagnostics at Clinical Genomics Stockholm and contribute to further advancements in rare disease research.


## Pipeline
<img src="https://github.com/nxl365/New_rank_score/blob/main/pipeline.png"  width="1000" height="150">   

script `finalscript_LG4_12feats_CJP_AF_args.py`  

The pipeline consists of four steps:  
1. Extract annotation data/features from the `INFO` column of MIPannotated `vcf.gz` file:  
   * outside `CSQ`, some features are chosen  
   * inside `CSQ`, all features are collected:  
    since there are many overlapping Ensembl transcripts for each variant, we only select one transcript with the most severe ’Consequence’ and where the ’CANONICAL’ flag is set to ’YES’ out of them. And then get all features of it.

2. Data preprocessing and prediction:  
   select 12 features, and do preprocessing by fitted preprocessor, get the prediction(benign/pathogenic) and score/probability by fitted LG model
   ```
   'CADD','Frq','GNOMADAF_popmax','Consequence','BIOTYPE','PolyPhen','REVEL_score','pLI_gene_value','SpliceAI_pred_DS_AG','SpliceAI_pred_DS_AL','SpliceAI_pred_DS_DG','SpliceAI_pred_DS_DL'
   ```

4. Incorporating Allele frequency filtering:  
  If MAF > 0.01 and the model prediction is `pathogenic`, change `pathogenic` to `benign` without changing the score. The MAF is calculated as the minimum value among the AF-related variables, including ’AF_ESP’, ’AF_EXAC’, ’AF_TGP’, ’Frq’, ’GNOMADAF_popmax’, and ’SWEGENAF’, if any of these variables have a null value, it is skipped in the calculation

5. write the prediction and score output back to `vcf.gz` file

   
   




## Setup
1. Clone this repo
2. install a conda environment with the necessary dependencies
```
conda env create --name rank_score -f RS_env.yml
```

## Usage

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

* prepare your own input:  `--in`
  - for test, you can try the annotated `test_MIPannotated_part_clinvar_221113.vcf.gz` or `MIPannotated_KIpathogenic.vcf.gz`

* you will get 2 outputs:  `--info , --out`  
  - the extracted features `test_info.csv`  
  - the final output file with predictions and scores from LG model `test_out.vcf.gz`    

* Other parameters are stored in this repo  


## test data
* `test_MIPannotated_part_clinvar_221113.vcf.gz`: a part of the [public ClinVar](https://ftp.ncbi.nlm.nih.gov/pub/clinvar/vcf_GRCh37/weekly/clinvar_20221113.vcf.gz) after MIP annotated
* `test_clinvar_info.csv`: output extracted features from input `test_MIPannotated_part_clinvar_221113.vcf.gz`
* `test_clinvar_out.vcf.gz`: output file with predictions and scores of LG model from input `test_MIPannotated_part_clinvar_221113.vcf.gz`
* `KIpathogenic.vcf`: includes 977 pathogenic variants detected by the Genomic Medicine Center Karolinska-Rare Diseases ([GMCK-RD](https://pubmed.ncbi.nlm.nih.gov/33726816/)) and submitted to [ClinVar](https://www.ncbi.nlm.nih.gov/clinvar/?term=SUB8639822)
* `KIpathogenic.vcf.gz`: compressed `KIpathogenic.vcf`
* `KIpathogenic.vcf.gz.tbi`: the index of `KIpathogenic.vcf.gz`
* `KIpathogenic_fixed.vcf.gz`: output file after run `fixvcf.py`
* `MIPannotated_KIpathogenic.vcf.gz`: `KIpathogenic_fixed.vcf.gz` after MIP annotated 




