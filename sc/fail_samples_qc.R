## load sex, missing genotype, and heterozygous failing quality control check
## and outputs a file with unique samples to be filter out
setwd("~/scripts/gwas/sc/")
library(dplyr)

het_miss <- read.table("../data/qc/fail.sex.check.txt",
                       fill = TRUE, 
                       stringsAsFactors = FALSE,
                       header = FALSE)
het_miss <- select(het_miss, V1:V2)
head(het_miss)

sex <- read.table("../data/qc/fail.sex.check.txt",
                  fill = TRUE,
                  stringsAsFactors = TRUE)
sex <- select(sex, V1:V2)

fail_samples <- rbind(het_miss, sex)
dim(fail_samples)
fail_samples <- fail_samples[!duplicated(fail_samples),]
dim(fail_samples)
names(fail_samples) <- c("FID", "IID") 

write.table(fail_samples, "../data/qc/fail_samples_qc.txt",
            sep="\t", quote = FALSE, row.names = FALSE)
