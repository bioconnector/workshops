library(tidyverse)
# setwd to current

# create text file to use for wget. `cat` the file to ` | parallel wget`
meta <- read_tsv("airway_metadata_ena.tsv") %>%
  rename(id=run_accession, geo_id=experiment_alias) %>%
  inner_join(read_csv("../../data/airway_metadata.csv")) %>%
  select(id, geo_id, dex, celltype, everything()) %>%
  select(-fastq_md5)
meta
meta %>%
  mutate(fastq_ftp=strsplit(fastq_ftp, ";")) %>%
  unnest(fastq_ftp) %>%
  distinct %>%
  select(fastq_ftp) %>%
  write_delim("airway_wgetlist.txt", col_names=FALSE)

## Run Kallisto
# export OPTS="--plaintext -t 50 -i ~/genomes/ensembl-grch38/index-kallisto/INDEX"
# kallisto quant $OPTS -o SRR1039508 SRR1039508_1.fastq.gz SRR1039508_2.fastq.gz
# kallisto quant $OPTS -o SRR1039509 SRR1039509_1.fastq.gz SRR1039509_2.fastq.gz
# kallisto quant $OPTS -o SRR1039512 SRR1039512_1.fastq.gz SRR1039512_2.fastq.gz
# kallisto quant $OPTS -o SRR1039513 SRR1039513_1.fastq.gz SRR1039513_2.fastq.gz
# kallisto quant $OPTS -o SRR1039516 SRR1039516_1.fastq.gz SRR1039516_2.fastq.gz
# kallisto quant $OPTS -o SRR1039517 SRR1039517_1.fastq.gz SRR1039517_2.fastq.gz
# kallisto quant $OPTS -o SRR1039520 SRR1039520_1.fastq.gz SRR1039520_2.fastq.gz
# kallisto quant $OPTS -o SRR1039521 SRR1039521_1.fastq.gz SRR1039521_2.fastq.gz
## clean up
# mkdir reads && mv *.fastq.gz reads
# mkdir airway_kallisto && mv SRR* airway_kallisto
# find airway_kallisto/SRR*/abundance.tsv | xargs gzip

library(tximport)

files <- file.path("kallisto", meta$id, "abundance.tsv.gz")
names(files) <- meta$id
stopifnot(all(file.exists(files))); files

(tx2gene <- read_tsv("Homo_sapiens.GRCh38.tx2gene.tsv.gz", col_types="cc"))
txi <- tximport(files,
                type = "kallisto",
                tx2gene = tx2gene,
                reader = read_tsv,
                countsFromAbundance="lengthScaledTPM")

txicounts <- txi$counts %>%
  round %>%
  as.data.frame %>%
  rownames_to_column("ensgene") %>%
  tbl_df
txicounts
# txicounts %>% write_csv("../../data/airway_scaledcounts.csv")

txilength <- txi$length %>%
  round %>%
  as.data.frame %>%
  rownames_to_column("ensgene") %>%
  tbl_df
txilength
# txilength %>% write_csv("../../data/airway_length.csv")

txitpm <- txi$abundance %>%
  as.data.frame %>%
  round(2) %>%
  rownames_to_column("ensgene") %>%
  tbl_df
txitpm
# txitpm %>% write_csv("../../data/airway_tpm.csv")

