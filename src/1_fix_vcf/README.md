
## Fix original VCF formate for MIP annotation

## Module 
 - numpy, pysam, samtools(bgzip, tabix) ( for Mac M1, `brew install samtools` )

## Intro
Script: `fixvcf.py`

1. add new headers: `FORMAT ("GT" "DP" "AD" "GQ")`; `SAMPLE`  
   keep original records: `#CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO `
2. add values of `GT,AD,DP,GQ` under `SAMPLE`: 
  - GT: 1/1    (all homozygous Alt)
  - GQ: poisson distribution, mean=40, scale[10,60], int by default
  - DP: normal distribution, mean=30, SD = 10(set by myself), scale[10,50], then transfer float to int
  - AD: 1st(ref)—normal distribution, close to 0 (mean=0,SD=5,x ≥0); 2nd(alt)=DP-1st
3. if there are some tuple `alt` with none values in ori records, change to string `.`; and `ref` is already string, and can’t be none, so didn't change


## useage
1.  prepare files:
First you need to make sure the `vcf` file is compressed as a `vcf.gz` file.
Next, create a new `.tbi` index file of it. ( `-f` command will write over an old index file that may be outdated or corrupted; `-p` command will tell tabix to use the "vcf" file format.)
```
bgzip -c *.vcf > *.vcf.gz     
tabix -fp vcf *.vcf.gz          
```
for example, 2 files are required before we run the script:
```
pathogenic.vcf.gz
pathogenic.vcf.gz.tbi
```

2. fill input and output:
```
in_file = test_data/pathogenic.vcf.gz
out_file = test_data/pathogenic_fixed.vcf.gz
```

3. run this command
```
python3 fixvcf.py
```

   




