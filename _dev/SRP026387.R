setwd(file.path(rprojroot::find_rstudio_root_file(), "_dev"))

library(tidyverse)
library(recount)

# Get the data
accn <- "SRP026387"
download_study(accn) %>% print
load(file.path(accn, 'rse_gene.Rdata'))
unlink(file.path(accn), recursive = TRUE)

# scale the counts
rse <- scale_counts(rse_gene)

# Strip the version number
rownames(rse) <- rownames(rse) %>% stringr::str_extract("ENSG\\d+")

# Read in the annotation
anno <- read_csv("../data/annotables_grch38.csv", col_types=cols())

# # Check that they're in the annotation
table(rownames(rse) %in% anno$ensgene)

# Get rid of duplicates and those missing an annotation
rse <- rse[!duplicated(rownames(rse)) & rownames(rse) %in% anno$ensgene, ]

mycoldata <- colData(rse) %>%
  as.data.frame %>%
  rownames_to_column("id") %>%
  transmute(id,
            replicate=stringr::str_extract(title, "R\\d"),
            prepost=stringr::str_extract(characteristics, "Pre|Post") %>% factor) %>%
  tbl_df()
mycoldata
# mycoldata %>% write_csv("tmp_metadata.csv")

mycountdata <- assay(rse) %>%
  as.data.frame %>%
  rownames_to_column("ensgene") %>%
  tbl_df() %>%
  mutate_if(is.double, as.integer)
mycountdata
# mycountdata %>% write_csv("tmp_counts.csv")

library(DESeq2)
dds <- DESeqDataSetFromMatrix(
  data.frame(mycountdata, row.names = 1),
  data.frame(mycoldata, row.names = 1),
  design=~prepost
)
dds <- DESeq(dds)

# PCA
plotPCA(vst(dds), intgroup="prepost")

results(dds, tidy=TRUE) %>%
  tbl_df %>%
  arrange(desc(abs(stat))) %>%
  inner_join(anno, by=c("row"="ensgene")) %>%
  View
