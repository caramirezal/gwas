## transform 1000 genomes in ped format files to bed
#files=$(ls ~/scripts/snpsDataMining/data/1000genomes/ped | grep ped | sed "s/.ped//g")
#for f in $files; do
#     ./inst/plink \
#     --file ~/scripts/snpsDataMining/data/1000genomes/ped/$f \
#     --make-bed \
#     --out data/1000_genomes_mxn/$f
#done

files=$(ls data/1000_genomes_mxn | grep bed | sed "s/.bed//g")
for f in $files; do
      echo Processing $f

      ./inst/plink \
      --bfile data/1000_genomes_mxn_gsa/$f \
      --extract data/annotations/megan_rsids.txt \
      --make-bed \
      --out data/1000_genomes_mxn_megan/$f
done
#--extract data/annotations/gsa_rsids.txt
