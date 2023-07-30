
## Fix original VCF file from CliVar:
### Env
 - miniconda: pysam_3, boinfo;  
 - package(pysam, numpy, matplotlib)

### fixvcf.py
1. add new headers: `FORMAT "GT" "DP" "AD" "GQ"`; `SAMPLE`  
   keep original records: `#CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO `
2. add values of `GT,AD,DP,GQ` under `SAMPLE`: 
  - GT: 1/1    (all homozygous Alt)
  - GQ: poisson distribution, mean=40, scale[10,60], int by default
  - DP: normal distribution, mean=30, SD = 10(set by myself), scale[10,50], then transfer float to int
  - AD: 1st(ref)—normal distribution, close to 0 (mean=0,SD=5,x ≥0); 2nd(alt)=DP-1st
3. There are some tuple `alt` with none values in ori records, change to string `.`; and `ref` is already string, and can’t be none, so didn't change

### delno_fixvcf.py
  - based on `fixvcf.py`, do not add the original record line with none alt value


   




