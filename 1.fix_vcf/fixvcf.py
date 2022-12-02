import pysam


in_file = "sub_clinvar_20221113.vcf.gz"
out_file = "out.vcf.gz"

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
                ("Type", "String"),
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

        # try: add an fake example in record area 1st line
        r = vcf_out.new_record(
            contig=str(1), start=999, stop=1000, alleles=("A", "T"), filter="PASS"
        )

        r.samples["NA19909"]["GT"] = (1, 1)
        r.samples["NA19909"]["DP"] = str(30)
        r.samples["NA19909"]["AD"] = (25, 28)
        r.samples["NA19909"]["GQ"] = int(40)

        vcf_out.write(r)  # write this r to vcf file

        # add values of records of in_file to out_file
        for rec in vcf_in:
            # print(rec.chrom)
            # print(rec.alleles)
            # print(rec.start)
            # print(rec.stop)
            # print(rec.info)
            # print(rec.filter)
            # print(rec.qual)
            # print(rec.id)
            r = vcf_out.new_record(
                contig=str(rec.chrom),
                start=rec.start,
                stop=rec.stop,
                id=rec.id,
                alleles=rec.alleles,
                filter=rec.filter,
                info=rec.info,
                qual=rec.qual,
            )
            r.samples["NA19909"]["GT"] = (1, 1)
            r.samples["NA19909"]["DP"] = str(30)
            r.samples["NA19909"]["AD"] = (25, 28)
            r.samples["NA19909"]["GQ"] = int(40)

            vcf_out.write(r)
