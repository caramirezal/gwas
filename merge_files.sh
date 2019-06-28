## remove C->G, A->T markers
./inst/plink \
     --bfile data/miADN_raw \
     --extract data/qc/hapmap3r2_CEU.CHB.JPT.YRI.no-at-cg-snps.txt \
     --make-bed \
     --out data/miADN_no_cg_at
./inst/plink \
     --bfile data/miADN_raw \
     --extract data/qc/hapmap3r2_CEU.CHB.JPT.YRI.no-at-cg-snps.txt \
     --make-bed \
     --out data/miADN_no_cg_at

## try merge
./inst/plink \
     --bfile data/miADN_no_cg_at_no_miss \
     --bmerge data/1000_genomes_mxn_allChr_no_cg_at_no_miss \
     --make-bed \
     --out data/miADN_plus_mxn 

## remove SNPs with discrepancies
./inst/plink \
     --bfile data/miADN_no_cg_at \
     --exclude data/miADN_plus_mxn-merge.missnp \
     --make-bed \
     --out data/miADN_no_cg_at_no_miss
./inst/plink \
     --bfile data/1000_genomes_mxn_allChr_no_cg_at \
     --exclude data/miADN_plus_mxn-merge.missnp \
     --make-bed \
     --out data/1000_genomes_mxn_allChr_no_cg_at_no_miss


## merge
./inst/plink \
      --bfile data/miADN_no_cg_at_no_miss \
      --bmerge data/1000_genomes_mxn_allChr_no_cg_at_no_miss \
      --make-bed \
      --out data/miADN_plus_mxn
