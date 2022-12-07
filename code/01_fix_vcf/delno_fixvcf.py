"""this script for deleting the ALT none values in fixed_vcf file"""



import pysam
import numpy as np
from numpy import random


in_file = "clinvar_20221113.vcf.gz"
out_file = "del_fixed.vcf.gz"

# read the input vcf file
with pysam.VariantFile(in_file, "r") as vcf_in:

    # create an object of new vcf file and open in to write data.
    with pysam.VariantFile(out_file, "w", header=vcf_in.header) as vcf_out:

        # Add contig/chrom; Ffilter; format; sample to header
        vcf_out.header.add_meta("contig", items=[("ID", 1)])

        vcf_out.header.add_meta(
            "FILTER", items=[("ID", "PASS"), ("Description", "All filters passed")]
        )

        vcf_out.header.add_meta(
            "FORMAT",
            items=[
                ("ID", "GT"),
                ("Number", 1),
                ("Type", "String"),
                ("Description", "Genotype"),
            ],
        )
        vcf_out.header.add_meta(
            "FORMAT",
            items=[
                ("ID", "DP"),
                ("Number", 1),
                ("Type", "Integer"),
                (
                    "Description",
                    "Approximate read depth (reads with MQ=255 or with bad mates are filtered)",
                ),
            ],
        )
        vcf_out.header.add_meta(
            "FORMAT",
            items=[
                ("ID", "AD"),
                ("Number", "R"),
                ("Type", "Integer"),
                (
                    "Description",
                    "Allelic depths for the ref and alt alleles in the order listed",
                ),
            ],
        )
        vcf_out.header.add_meta(
            "FORMAT",
            items=[
                ("ID", "GQ"),
                ("Number", 1),
                ("Type", "Integer"),
                ("Description", "Genotype Quality"),
            ],
        )

        vcf_out.header.add_samples("NA19909")
        # print(vcf_out.header)

        # add records:

        for rec in vcf_in:

            # change tuple alts to string, and drop out all variants with none ALT
            # type(rec.alts)--tuple ; type(rec.ref)--string. transfer tuple to string in order to add in "ALT" column
            if rec.alts is not None:
                str_alts = " ".join(rec.alts)

                # add original info
                r = vcf_out.new_record(
                    contig=str(rec.chrom),
                    start=rec.start,
                    stop=rec.stop,
                    id=rec.id,
                    alleles=(rec.ref, str_alts),  # alleles=rec.alleles , also works
                    filter=rec.filter,
                    info=rec.info,
                    qual=rec.qual,
                )

                # add Genotype
                r.samples["NA19909"]["GT"] = (1, 1)  # homozygous Alt, tuple

                # add read depth
                dp = 0
                while dp < 10 or dp > 50:
                    dp = np.random.normal(
                        30, 10
                    )  # normal distri, mu/mean=30,sigma/SD=10, float
                    dp = int(dp)
                r.samples["NA19909"]["DP"] = dp  # close to sum up AD

                # add Allelic depth
                a1 = -1
                while a1 < 0:
                    a1 = int(np.random.normal(0, 5))  # normal distri, mu=0,sigma=5
                a2 = dp - a1
                r.samples["NA19909"]["AD"] = (a1, a2)  # tuple--1st: close to 0; 2nd: DP-1st

                # add Genotype Quality
                gq = 0
                while gq < 10 or gq > 60:
                    gq = np.random.poisson(lam=40)  # poisson distri, int
                r.samples["NA19909"]["GQ"] = int(gq)

                vcf_out.write(r)  # write to vcf file

            else:
                continue   # if ALT is none, add noting and continue to next loop

