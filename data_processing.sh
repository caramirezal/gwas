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

## Calculation of similarity between samples
## using IBS metric
./inst/plink --bfile data/qc/miADN_updated_sex \
             --extract data/qc/miADN.prune.in \
             --genome --out data/qc/miADN 


## remove samples that fails to pass sample qc
./inst/plink --bfile data/qc/miADN_updated_sex \
             --remove data/qc/fail_samples_qc.txt \
             --make-bed --out data/qc/miADN_sample_clean


## test missing data differences between samples and controls
## to filter out SNPs 
./inst/plink --bfile data/qc/miADN_sample_clean \
             --test-missing \
             --pheno data/annotations/cases_vs_controls.ann.txt \
             --out data/qc/miADN_sample_clean

## download script to process previous SNP sample vs control missing values QC
wget https://raw.githubusercontent.com/guigotoe/ExomeChip/master/bin/run-diffmiss-qc.pl -P inst/

## extract statistical significat SNP with missing data
## between cases and controls 
## outputs a file name fail-diff-miss-qc-txt
perl inst/run-diffmiss-qc.pl data/qc/miADN_sample_clean 

## final SNP filtering by:
## missing data differentially in cases or controls
## minor allele frequency
## Hardy-Weinberg equilibrium
## missing SNP genotyping (--geno)
./inst/plink --bfile data/qc/miADN_sample_clean \
             --exclude data/qc/fail-diffmiss-qc.txt \
             --maf 0.01 --geno 0.05 --hwe 0.00001 \
             --make-bed -out data/qc/miADN_clean


#################################################################################3
## performing divergent analysis

## Downloading hapmap SNPs which are not C->G or A->T files
wget https://raw.githubusercontent.com/genepi-freiburg/gwas/master/cleaning-pipeline/aux/hapmap3r2_CEU.CHB.JPT.YRI.no-at-cg-snps.txt \
     -P data/qc/

## extracting above SNPs
./inst/plink --bfile data/qc/miADN_clean \
             --extract data/qc/hapmap3r2_CEU.CHB.JPT.YRI.no-at-cg-snps.txt \
             --make-bed --out data/qc/miADN_clean.hapmap-snps
