# Introduction of ML code

1. we tried models with 29 or 12 features:

* 29 features:
```
'CADD', 'AF_TGP', 'Frq', 'IMPACT','GNOMADAF_popmax', 'Hom', 'ORIGIN',
'SPIDEX', 'SWEGENAF', 'Consequence', 'BIOTYPE', 'SIFT',
'PolyPhen', 'MES-SWA_acceptor_alt', 'MES-SWA_acceptor_diff',
'MES-SWA_donor_alt', 'MES-SWA_donor_diff', 'MaxEntScan_alt',
'MaxEntScan_diff', 'GERP++_RS', 'REVEL_score',
'phastCons100way_vertebrate', 'phyloP100way_vertebrate', 'LoFtool',
'pLI_gene_value', 'SpliceAI_pred_DS_AG', 'SpliceAI_pred_DS_AL',
'SpliceAI_pred_DS_DG', 'SpliceAI_pred_DS_DL'
```

* 12 features:
```
'CADD',
'Frq',
'GNOMADAF_popmax',
'Consequence',
'BIOTYPE',
'PolyPhen',
'REVEL_score',
'pLI_gene_value',
'SpliceAI_pred_DS_AG',
'SpliceAI_pred_DS_AL',
'SpliceAI_pred_DS_DG',
'SpliceAI_pred_DS_DL'

```


2. we trained different LG models:

```
LG1      trained on imbalanced ClinVar data with 29 features
LG2      trained on imbalanced ClinVar data with 12 features
LG3      trained on imbalanced CJP data with 12 features
LG4      LG3 + Allele frequency filter
```