
Fix original VCF file from CliVar:

add new headers:
     ##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">
     ##FORMAT=<ID=DP,Number=1,Type=Integer,Description="Approximate read depth (reads with MQ=255 or with bad mates are filtered)">
     ##FORMAT=<ID=AD,Number=R,Type=Integer,Description="Allelic depths for the ref and alt alleles in the order listed">
     ##FORMAT=<ID=GQ,Number=1,Type=Integer,Description="Genotype Quality">

     ##FILTER=<ID=PASS,Description="All filters passed">
     ##contig=<ID=1>

