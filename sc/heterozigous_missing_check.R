## Create het vs missing snps plots
setwd("~/scripts/gwas/sc/")
library(dplyr)
library(ggplot2)

## Read heterozigous check
het <- read.table("../data/qc/miADN.het",
                  fill=TRUE, sep="", header = TRUE)

## Read snp missing data
missing <- read.table("../data/qc/miADN.imiss",
                      fill=TRUE, sep="", header = TRUE)
head(missing)

## merge both checks
check <- merge(het, missing)
head(check)
dim(check)
names(check) <- gsub("\\.", "", names(check))
check <- mutate(check, HET=(NNM-OHOM)/NNM)
head(check)

## plot het vs missing snps
theme_set(theme_light())
pdf("../figures/heterozygous_vs_missing.pdf")
ggplot(data=check, aes(x=F_MISS, y=HET)) + 
        geom_point() + 
        geom_vline(xintercept = 0.03, color="red", 
                   linetype="dotted", size=0.8) +
        geom_hline(yintercept = 0.22, color="red", 
                   linetype="dotted", size=0.8) +
        xlab("Missing genotyping") +
        ylab("Heterozygous frequency") +
        theme(axis.title.x = element_text(size = 16, face="bold"),
              axis.title.y = element_text(size=16, face = "bold"))
dev.off()

head(check)     ## threshold cutoffs  missing=0.03, het=0.22
dim(check)
fail.check <- filter(check, HET>0.22 | F_MISS>0.03)
dim(fail.check)

write.table(fail.check, "../data/qc/fail.heterozygous_missing.tsv",
            sep = "\t", row.names = FALSE, quote = FALSE)
