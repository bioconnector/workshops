library(tidyverse)

rc <- read_csv("data/airway_rawcounts.csv")
sc <- read_csv("data/airway_scaledcounts.csv")

rc <- rc %>% filter(ensgene %in% intersect(rc$ensgene, sc$ensgene))
sc <- sc %>% filter(ensgene %in% intersect(rc$ensgene, sc$ensgene))

stopifnot(identical(rc$ensgene, sc$ensgene))
stopifnot(dim(rc)==dim(sc))

rcm <- rc %>% as.data.frame %>% column_to_rownames("ensgene") %>% as.matrix
scm <- sc %>% as.data.frame %>% column_to_rownames("ensgene") %>% as.matrix

plot(rcm, scm, log="xy")

tidyc <- inner_join(rc %>% gather(sample, raw, -ensgene),
                    sc %>% gather(sample, scaled, -ensgene))

ggplot(tidyc, aes(raw, scaled)) + geom_point() + facet_wrap(~sample) + scale_x_log10() + scale_y_log10()
ggplot(tidyc, aes(scaled, raw)) +
  geom_point(alpha=1/5) +
  geom_smooth(method="lm", se=F, col="blue") +
  geom_abline(slope=1, intercept=0, col="red") +
  facet_wrap(~sample) +
  scale_x_log10() +
  scale_y_log10()


