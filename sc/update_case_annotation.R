## Creates update sex file for plink files
setwd("~/scripts/gwas/sc/")
library(dplyr)

## read first two columns of the ped files
## constructed with bash by running:
## cat data/genotyping/megan/miADN.ped | cut -f1-2 > data/genotyping/qc/fid_iid_cols.txt
ids <- read.table("../data/fid_iid_cols.txt",
                  sep="\t", header = FALSE, stringsAsFactors = FALSE)
str(ids)
names(ids) <- c("FIID", "ID_MAP_FILE")
str(ids)

## read annotations
annotations <- read.table("../data/annotations/metadata_revised.tsv",
                          sep="\t", header = TRUE, stringsAsFactors = FALSE)
str(annotations)

## Annotate fid and iid with sex info
cases <- merge(ids, annotations)
str(cases)

## store the info
cases <- select(cases, FIID, ID_MAP_FILE, CATEGORY) %>%
                arrange(FIID)
cases$CATEGORY <- plyr::mapvalues(cases$CATEGORY, 
                              from = c("NON ATHLETE", "POWER", "ENDURANCE"),
                              to=c(1,1,2))
table(cases$CATEGORY)
head(cases)
write.table(cases, "../data/annotations/cases_vs_controls.ann.txt",
            sep="\t", quote = FALSE, 
            col.names = FALSE, row.names = FALSE)

