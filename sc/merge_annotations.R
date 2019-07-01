## merge annotations for miADN athletes and 1000genomes controls
library(dplyr)

## read 1000 genomes annotations
mapgenomes <- read.table("../data/annotations/mxn_1000_genomes_annotations.txt",
                         sep="\t", header = FALSE, stringsAsFactors = FALSE)

## read miADN anntoations
miADN <- read.table("../data/annotations/metadata_revised.tsv",
                    sep = "\t", 
                    stringsAsFactors = FALSE,
                    header = TRUE)

## read FID and IID from fam files 
fam_ann <- read.table("../data/miADN_plus_mxn.fam",
                      stringsAsFactors = FALSE,
                      header = FALSE)

## process map_genomes to bind with miADN
control <- rep("control", nrow(mapgenomes))
mgenomes.p <- select(mapgenomes, V1:V4) %>%
               rename(FID=V1, GENERA=V2, IID=V3, ETNIA=V4)
mgenomes.p <- mutate(mgenomes.p, 
                   ID=FID,
                   ID_MAP_FILE=FID,
                   GENERA=toupper(GENERA),
                   ETNIA=control,
                   DISCIPLINE=control,
                   ACHIEVEMENT=control,
                   CATEGORY=control) 
mgenomes.p <- mgenomes.p[, names(miADN)]

## bind 1000genomes and MIADN annotations
miADN_plus_mxn_metadata <- rbind(miADN, mgenomes.p)
write.table(miADN_plus_mxn_metadata,
            "../data/annotations/metadata_miADN_plus_mxn.tsv",
            quote = FALSE, 
            row.names = FALSE,
            sep = "\t")

## annotate miADN_plus_mxn fam file
miADN_plus_mxn_metadata <- rename(miADN_plus_mxn_metadata, 
                                  IID=ID_MAP_FILE)
annotated_fam <- merge(fam_ann, miADN_plus_mxn_metadata,
                             all.x = TRUE)
write.table(annotated_fam, 
      "../data/annotations/miADN_plus_mxn_annotated_list.txt",
      sep = "\t",
      quote = FALSE,
      row.names = FALSE)
