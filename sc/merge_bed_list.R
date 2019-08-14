## create merge-list file in order to merge bed files

## files to merge must be merged in the next format
## file1.bed file1.bim file1.fam
## file2.bed file2.bim file2.fam
## ...
## filen.bed filen.bim filen.fam

## Loading file names and creating above defined format
setwd('/media/cramirezal/TOSHIBA EXT/mi_adn_respaldo_julio_2019/gwas/sc/')
fpath <- "../data/1000_genomes_mxn/"
files <- list.files(fpath)
files.chunked <- unique(gsub("\\..*", "", files))
files.chunked <- files.chunked[!grepl( "MT",files.chunked)]
file_list <- data.frame("bed"=paste0("data/1000_genomes_mxn_megan/", files.chunked, ".bed"),
                        "bim"=paste0("data/1000_genomes_mxn_megan/", files.chunked, ".bim"),
                        "fam"=paste0("data/1000_genomes_mxn_megan/", files.chunked, ".fam"))

## writting format
write.table(file_list, "../data/annotations/merge_bed_list.txt",
            sep=" ", quote = FALSE, row.names = FALSE, col.names=FALSE)
