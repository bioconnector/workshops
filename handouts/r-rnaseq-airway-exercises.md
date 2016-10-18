---
title: 'RNA-seq Workshop Exercises'
output: pdf_document
---

## Exercise 1

If we look at our metadata, we see that the control samples are SRR1039508, SRR1039512, SRR1039516, and SRR1039520. This bit of code will take the rawcounts data, mutate it to add a column called `controlmean`, then select only the gene name and this newly created column, and assigning the result to a new object called `meancounts`.


```r
meancounts <- rawcounts %>% 
  mutate(controlmean = SRR1039508+SRR1039512+SRR1039516+SRR1039520) %>% 
  select(ensgene, controlmean)
meancounts
```

```
## Source: local data frame [64,102 x 2]
## 
##            ensgene controlmean
##              (chr)       (int)
## 1  ENSG00000000003        3460
## 2  ENSG00000000005           0
## 3  ENSG00000000419        2092
## 4  ENSG00000000457        1001
## 5  ENSG00000000460         254
## 6  ENSG00000000938           3
## 7  ENSG00000000971       21325
## 8  ENSG00000001036        5949
## 9  ENSG00000001084        2630
## 10 ENSG00000001167        1876
## ..             ...         ...
```

1. Build off of this code, `mutate` it once more (prior to the `select()`) function, to add another column called `treatedmean` that takes the mean of the expression values of the treated samples. Then `select` only the `ensgene`, `controlmean` and `treatedmean` columns, assigning it to a new object called meancounts. It should look like this.


```
## Source: local data frame [64,102 x 3]
## 
##            ensgene controlmean treatedmean
##              (chr)       (int)       (int)
## 1  ENSG00000000003        3460        2475
## 2  ENSG00000000005           0           0
## 3  ENSG00000000419        2092        2187
## 4  ENSG00000000457        1001         935
## 5  ENSG00000000460         254         213
## 6  ENSG00000000938           3           0
## 7  ENSG00000000971       21325       26953
## 8  ENSG00000001036        5949        4491
## 9  ENSG00000001084        2630        2291
## 10 ENSG00000001167        1876        1264
## ..             ...         ...         ...
```

2. Directly comparing the raw counts is going to be problematic if we just happened to sequence one group at a higher depth than another. Later on we'll do this analysis properly, normalizing by sequencing depth. But for now, `summarize()` the data to show the `sum` of the mean counts across all genes for each group. Your answer should look like this:


```
## Source: local data frame [1 x 2]
## 
##   sum(controlmean) sum(treatedmean)
##              (int)            (int)
## 1         89561179         85955244
```


## Exercise 2

1. Create a scatter plot showing the mean of the treated samples against the mean of the control samples.

![](r-rnaseq-airway_files/figure-html/simplescatter-1.png)


2. Wait a sec. There are 60,000-some rows in this data, but I'm only seeing a few dozen dots at most outside of the big clump around the origin. Try plotting both axes on a log scale (_hint_: `... + scale_..._log10()`)

![](r-rnaseq-airway_files/figure-html/simplescatterlog-1.png)


## Exercise 3

Go back and refresh your memory on [using `inner_join()` to join two tables by a common column/key](r-tidy.html#inner_join-it-to-the-gene-ontology-information). You previously downloaded [annotables_grch37.csv](http://bioconnector.org/data/annotables_grch37.csv) from [bioconnector.org/data](http://bioconnector.org/data/). Load this data with `read_csv()` into an object called `anno`. Pipe it to `View` or click on the object in the Environment pane to view the entire dataset. This table links the unambiguous Ensembl gene ID to things like the gene symbol, full gene name, location, Entrez gene ID, etc.


```r
anno <- read_csv("data/annotables_grch37.csv")
anno
```

```
## Source: local data frame [67,416 x 9]
## 
##            ensgene entrez   symbol   chr     start       end strand
##              (chr)  (int)    (chr) (chr)     (int)     (int)  (int)
## 1  ENSG00000000003   7105   TSPAN6     X  99883667  99894988     -1
## 2  ENSG00000000005  64102     TNMD     X  99839799  99854882      1
## 3  ENSG00000000419   8813     DPM1    20  49551404  49575092     -1
## 4  ENSG00000000457  57147    SCYL3     1 169818772 169863408     -1
## 5  ENSG00000000460  55732 C1orf112     1 169631245 169823221      1
## 6  ENSG00000000938   2268      FGR     1  27938575  27961788     -1
## 7  ENSG00000000971   3075      CFH     1 196621008 196716634      1
## 8  ENSG00000001036   2519    FUCA2     6 143815948 143832827     -1
## 9  ENSG00000001084   2729     GCLC     6  53362139  53481768     -1
## 10 ENSG00000001167   4800     NFYA     6  41040684  41067715      1
## ..             ...    ...      ...   ...       ...       ...    ...
## Variables not shown: biotype (chr), description (chr)
```

1. Take our newly created `meancounts` object, and arrange it `desc`ending by the absolute value (`abs()`) of the `log2fc` column. The results should look like this:


```
## Source: local data frame [27,450 x 4]
## 
##            ensgene controlmean treatedmean    log2fc
##              (chr)       (int)       (int)     (dbl)
## 1  ENSG00000109906          22        2862  7.023376
## 2  ENSG00000250978           6         411  6.098032
## 3  ENSG00000128285          55           1 -5.781360
## 4  ENSG00000260802           1          48  5.584963
## 5  ENSG00000171819          38        1670  5.457705
## 6  ENSG00000137673           1          41  5.357552
## 7  ENSG00000127954          60        1797  4.904484
## 8  ENSG00000249364           2          59  4.882643
## 9  ENSG00000267339         222           8 -4.794416
## 10 ENSG00000100033          15         375  4.643856
## ..             ...         ...         ...       ...
```

2. Continue on that pipeline, and `inner_join()` it to the `anno` data by the `ensgene` column. Either assign it to a temporary object or pipe the whole thing to `View` to take a look. What do you notice? Would you trust these results? Why or why not?


```
## Source: local data frame [29,034 x 12]
## 
##            ensgene controlmean treatedmean    log2fc    entrez
##              (chr)       (int)       (int)     (dbl)     (int)
## 1  ENSG00000109906          22        2862  7.023376      7704
## 2  ENSG00000250978           6         411  6.098032        NA
## 3  ENSG00000128285          55           1 -5.781360      2847
## 4  ENSG00000260802           1          48  5.584963    401613
## 5  ENSG00000171819          38        1670  5.457705     10218
## 6  ENSG00000137673           1          41  5.357552      4316
## 7  ENSG00000127954          60        1797  4.904484     79689
## 8  ENSG00000249364           2          59  4.882643 101928858
## 9  ENSG00000267339         222           8 -4.794416    148145
## 10 ENSG00000100033          15         375  4.643856      5625
## ..             ...         ...         ...       ...       ...
## Variables not shown: symbol (chr), chr (chr), start (int), end (int),
##   strand (int), biotype (chr), description (chr)
```

## Exercise 4

1. Using a `%>%`, `arrange` the results by the adjusted p-value.


```
## Source: local data frame [64,102 x 7]
## 
##                row   baseMean log2FoldChange      lfcSE      stat
##              (chr)      (dbl)          (dbl)      (dbl)     (dbl)
## 1  ENSG00000152583   997.4398       4.285847 0.19605831  21.86006
## 2  ENSG00000148175 11193.7188       1.434388 0.08411178  17.05336
## 3  ENSG00000179094   776.5967       2.984244 0.18864120  15.81968
## 4  ENSG00000109906   385.0710       5.137007 0.33077733  15.53010
## 5  ENSG00000134686  2737.9820       1.368176 0.09059205  15.10261
## 6  ENSG00000125148  3656.2528       2.127162 0.14255648  14.92154
## 7  ENSG00000120129  3409.0294       2.763614 0.18915513  14.61030
## 8  ENSG00000189221  2341.7673       3.043757 0.21020671  14.47983
## 9  ENSG00000178695  2649.8501      -2.374629 0.17015595 -13.95560
## 10 ENSG00000101347 12703.3871       3.414854 0.24787488  13.77652
## ..             ...        ...            ...        ...       ...
## Variables not shown: pvalue (dbl), padj (dbl)
```

2. Continue piping to `inner_join()`, joining the results to the `anno` object. See the help for `?inner_join`, specifically the `by=` argument. You'll have to do something like `... %>% inner_join(anno, by=c("row"="ensgene"))`. Once you're happy with this result, reassign the result back to `res`. It'll look like this.


```
##               row   baseMean log2FoldChange      lfcSE     stat
## 1 ENSG00000152583   997.4398       4.285847 0.19605831 21.86006
## 2 ENSG00000148175 11193.7188       1.434388 0.08411178 17.05336
## 3 ENSG00000179094   776.5967       2.984244 0.18864120 15.81968
## 4 ENSG00000179094   776.5967       2.984244 0.18864120 15.81968
## 5 ENSG00000109906   385.0710       5.137007 0.33077733 15.53010
## 6 ENSG00000134686  2737.9820       1.368176 0.09059205 15.10261
##          pvalue          padj    entrez  symbol chr     start       end
## 1 6.235872e-106 1.119464e-101      8404 SPARCL1   4  88394487  88452213
## 2  3.300017e-65  2.962096e-61      2040    STOM   9 124101355 124132531
## 3  2.276377e-56  1.362184e-52 102465532    PER1  17   8043790   8059824
## 4  2.276377e-56  1.362184e-52      5187    PER1  17   8043790   8059824
## 5  2.170243e-54  9.740052e-51      7704  ZBTB16  11 113930315 114121398
## 6  1.556576e-51  5.588730e-48      1912    PHC2   1  33789224  33896653
##   strand        biotype
## 1     -1 protein_coding
## 2     -1 protein_coding
## 3     -1 protein_coding
## 4     -1 protein_coding
## 5      1 protein_coding
## 6     -1 protein_coding
##                                                               description
## 1                     SPARC-like 1 (hevin) [Source:HGNC Symbol;Acc:11220]
## 2                                  stomatin [Source:HGNC Symbol;Acc:3383]
## 3                  period circadian clock 1 [Source:HGNC Symbol;Acc:8845]
## 4                  period circadian clock 1 [Source:HGNC Symbol;Acc:8845]
## 5 zinc finger and BTB domain containing 16 [Source:HGNC Symbol;Acc:12930]
## 6       polyhomeotic homolog 2 (Drosophila) [Source:HGNC Symbol;Acc:3183]
```

3. How many are significant with an adjusted p-value <0.05? (Pipe to `filter()`).


```
## Source: local data frame [2,852 x 15]
## 
##                row   baseMean log2FoldChange      lfcSE      stat
##              (chr)      (dbl)          (dbl)      (dbl)     (dbl)
## 1  ENSG00000152583   997.4398       4.285847 0.19605831  21.86006
## 2  ENSG00000148175 11193.7188       1.434388 0.08411178  17.05336
## 3  ENSG00000179094   776.5967       2.984244 0.18864120  15.81968
## 4  ENSG00000179094   776.5967       2.984244 0.18864120  15.81968
## 5  ENSG00000109906   385.0710       5.137007 0.33077733  15.53010
## 6  ENSG00000134686  2737.9820       1.368176 0.09059205  15.10261
## 7  ENSG00000125148  3656.2528       2.127162 0.14255648  14.92154
## 8  ENSG00000120129  3409.0294       2.763614 0.18915513  14.61030
## 9  ENSG00000189221  2341.7673       3.043757 0.21020671  14.47983
## 10 ENSG00000178695  2649.8501      -2.374629 0.17015595 -13.95560
## ..             ...        ...            ...        ...       ...
## Variables not shown: pvalue (dbl), padj (dbl), entrez (int), symbol (chr),
##   chr (chr), start (int), end (int), strand (int), biotype (chr),
##   description (chr)
```

## Exercise 5


Look up the Wikipedia articles on [MA plots](https://en.wikipedia.org/wiki/MA_plot) and [volcano plots](https://en.wikipedia.org/wiki/Volcano_plot_(statistics)). An MA plot shows the average expression on the X-axis and the log fold change on the y-axis. A volcano plot shows the log fold change on the X-axis, and the $-log_{10}$ of the p-value on the Y-axis (the more significant the p-value, the larger the $-log_{10}$ of that value will be).

1. Make an MA plot. Use a $log_{10}$-scaled x-axis, color-code by whether the gene is significant, and give your plot a title. It should look like this. What's the deal with the gray points?


![](r-rnaseq-airway_files/figure-html/maplot-1.png)


2. Make a volcano plot. Similarly, color-code by whether it's significant or not.

![](r-rnaseq-airway_files/figure-html/volcanoplot-1.png)
