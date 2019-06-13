## Creates update sex file for plink files
library(dplyr)

## read first two columns of the ped files
## constructed with bash by running:
## cat data/genotyping/megan/miADN.ped | cut -f1-2 > data/genotyping/qc/fid_iid_cols.txt
ids <- read.table("../data/genotyping/qc/fid_iid_cols.txt",
                  sep="\t", header = FALSE, stringsAsFactors = FALSE)
str(ids)
names(ids) <- c("FIID", "ID_MAP_FILE")
str(ids)

## read annotations
annotations <- read.table("../data/genotyping/annotations/metadata_revised.tsv",
                          sep="\t", header = TRUE, stringsAsFactors = FALSE)
str(annotations)

## Annotate fid and iid with sex info
sex <- merge(ids, annotations)
str(sex)

## store the info
sex <- select(sex, FIID, ID, GENERA) %>%
          arrange(FIID)
sex$GENERA <- plyr::mapvalues(sex$GENERA, 
                              from = c("MALE", "FEMALE"),
                              to=c(1,2))
table(sex$GENERA)
write.table(sex, "../data/genotyping/qc/update_sex.txt",
            sep="\t", quote = FALSE, 
            col.names = FALSE, row.names = FALSE)

