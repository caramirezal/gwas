## Data processing and QC of the samples gentyped using Illumina megan

## transforming ped and map files to bed fam files
./inst/plink --file data/genotyping/megan/miADN --make-bed --out data/genotyping/bed/miADN

## update sex data with the data stored in update_sex.txt
## constructed with the update_sex.R file
./inst/plink --bfile data/genotyping/bed/miADN \
             --update-sex data/genotyping/qc/update_sex.txt \
             --make-bed --out data/genotyping/qc/miADN_updated_sex

## Sex check analysis
./inst/plink --bfile data/genotyping/qc/miADN_updated_sex --check-sex \
             --out data/genotyping/qc/miADN

## missing data check
./inst/plink --bfile data/genotyping/qc/miADN_updated_sex --missing \
             --out data/genotyping/qc/miADN

## homozygous check
./inst/plink --bfile data/genotyping/qc/miADN_updated_sex \
             --het --out data/genotyping/qc/miADN

## Download high LD regions
wget https://raw.githubusercontent.com/genepi-freiburg/gwas/master/single-pca/high-LD-regions.txt -P data/


## prune high LD chromosome locations
./inst/plink --bfile data/qc/miADN_updated_sex \
             --exclude data/high-LD-regions.txt \
             --range --indep-pairwise 50 5 0.2 \
             --out data/qc/miADN
