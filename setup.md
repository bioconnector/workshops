---
title: 'Setup Instructions'
---

## R

### R+RStudio+Packages

**Note:** R and RStudio are separate downloads and installations. **R** is the underlying statistical computing environment, but using R alone is no fun. **RStudio** is a graphical integrated development environment that makes using R much easier. You need R installed before you install RStudio.

1. **Install R.** You'll need R version **3.1.2** or higher.[^rversion] Download and install R for [Windows](http://cran.r-project.org/bin/windows/base/) or [Mac OS X](http://cran.r-project.org/bin/macosx/) (download the latest R-3.x.x.pkg file for your appropriate version of OS X).
1. **Install RStudio.** Download and install [RStudio Desktop](https://www.rstudio.com/products/rstudio/download/).
1. **Install R packages.** Launch RStudio (RStudio, *not R itself*). Ensure that you have internet access, then enter the following commands into the **Console** panel (usually the lower-left panel, by default). _A few notes_:
    - Commands are case-sensitive. 
    - You must be connected to the internet.
    - The [tidyverse](https://github.com/tidyverse/tidyverse#readme) package is kind of a meta-package that automatically installs/loads many core packages that we use throughout the workshops.[^tidyverse]
    - Even if you've installed these packages in the past, do re-install the most recent version. Many of these packages are updated often, and we may use new features in the workshop that aren't available in older versions.
    - If you're using Windows you might see errors about not having permission to modify the existing libraries -- disregard these. You can avoid this by running RStudio as an administrator (right click the RStudio icon, then click "Run as Administrator").

[^rversion]: R version 3.1.2 was released October 2014. If you have not updated your R installation since then, you need to upgrade to a more recent version, since several of the required packages depend on a version at least this recent. You can check your R version with the `sessionInfo()` command.

[^tidyverse]: Installing/loading the tidyverse **tidyverse** will install/load the core tidyverse packages that you are likely to use in almost every analysis:
**ggplot2** (for data visualisation), **dplyr** (for data manipulation), **tidyr** (for data tidying), **readr** (for data import), **purrr** (for functional programming), and **tibble** (for tibbles, a modern re-imagining of data frames). It also installs a selection of other tidyverse packages that you're likely to use frequently, but probably not in every analysis (these are installed, but you'll have to load them separately with `library(packageName)`). This includes:
**hms** (for times), **stringr** (for strings), **lubridate** (for date/times), **forcats** (for factors), **DBI** (for databases), **haven** (for SPSS, SAS and Stata files), **httr** (for web apis), **jsonlite** (or JSON), **readxl** (for .xls and .xlsx files), **rvest** (for web scraping), **xml2** (for XML), **modelr** (for modelling within a pipeline), and **broom** (for turning models into tidy data). After installing tidyverse with `install.packages("tidyverse")` and loading it with `library(tidyverse)`, you can use `tidyverse_update()` to update all the tidyverse packages installed on your system at once.

```r
install.packages("tidyverse")
```

You can check that you've installed everything correctly by closing and reopening RStudio and entering the following commands at the console window (don't worry about the _Conflicts with tidy packages_ warning):

```r
library(tidyverse)
```

This may produce some notes or other output, but as long as you don't get an error message, you're good to go. If you get a message that says something like: `Error in library(packageName) : there is no package called 'packageName'`, then the required packages did not install correctly. Please do not hesitate to [email me](people.html) _prior to the course_ if you are still having difficulty.

### Bioconductor

For some classes (e.g., RNA-seq), you'll need to install a few [Bioconductor](http://bioconductor.org/) packages. These packages are installed differently than "regular" R packages from CRAN. Copy and paste these lines of code into your R console. 

```r
source("http://bioconductor.org/biocLite.R")
biocLite()
biocLite("DESeq2")
```

A few notes:

- R may ask you if you want to update any old packages by asking `Update all/some/none? [a/s/n]:`. If you see this, type **`a`** at the propt and hit `Enter` to update any old packages. 
- If you see a note long the lines of "_binary version available but the source version is later_", followed by a question, "_Do you want to install from sources the package which needs compilation? y/n_", type **`n` for no**, and hit enter.
- You can check that you've installed everything correctly by closing and reopening RStudio and entering the following commands at the console window:

```r
library(DESeq2)
```

If you get a message that says something like: `Error in library(DESeq2) : there is no package called 'DESeq2'`, then the required packages did not install correctly. Please do not hesitate to [email me](people.html) _prior to the course_ if you are still having difficulty.


### RMarkdown

Several additional setup steps required for the reproducible research with RMarkdown class.

1. First, install R, RStudio, and the tidyverse package as described above. Also install the knitr and rmarkdown packages.
```r
install.packages("knitr")
install.packages("rmarkdown")
```
1. Next, launch RStudio (not R). Click File, New File, R Markdown. This may tell you that you need to install additional packages (`knitr`, `yaml`, `htmltools`, `caTools`, `bitops`, and `rmarkdown`). Click "Yes" to install these.
1. Sign up for a free account at **[RPubs.com](http://rpubs.com/)**.
1. **_Optional_:** If you want to convert to PDF, you will need to install a **LaTeX** typesetting engine. This differs on Mac and Windows. _Note that this part of the installation may take up to several hours, and isn't strictly required for the class._
    - **Windows LaTeX instructions**:
        1. Download the installer [using this link](http://mirrors.ctan.org/systems/win32/miktex/setup/setup-2.9.5870-x64.exe) (or [this link](http://mirrors.ctan.org/systems/win32/miktex/setup/setup-2.9.5870.exe) if you're using an older 32-bit version of Windows). It is important to use the full installer, not the basic installer. Run the installer .exe that you downloaded.
        1. Run the installer _twice_, making sure to use the Complete, not Basic, installation:
            1. First, When prompted, select the box to "Download MiKTeX." Select the closest mirror to your location. If you're doing this from Charlottesville, the United States / JMU mirror is likely the closest. This may take a while.
            1. Run the installer again, but this time select "Install" instead of "Download." When prompted _"Install missing packages on-the-fly"_, drag your selection up to "Yes."
    - **Mac LaTeX instructions**:
        1. Download the installer .pkg file [using this link](http://tug.org/cgi-bin/mactex-download/MacTeX.pkg). This is a very large download (>2 gigabytes). It can take a while depending on your network speed.
        1. Run the installer package.


### Interactive Visualization

The [Interactive Visualization with JavaScript and R](r-interactive-viz.html) lesson requires installation of several R packages in addition to those mentioned above:

```r
install.packages("highcharter")
install.packages("d3heatmap")
install.packages("leaflet")
install.packages("visNetwork")
install.packages("jsonlite")
```

To check that these are correctly installed, first close RStudio and then reopen it and run the following:

```r
library(highcharter)
library(d3heatmap)
library(leaflet)
library(visNetwork)
library(jsonlite)
```

These commands may produce some notes or other output, but as long as they work without an error message, you're good to go. If you get a message that says something like: `Error in library(packageName) : there is no package called 'packageName'`, then the required packages did not install correctly. Please do not hesitate to [email me](people.html) _prior to the course_ if you are still having difficulty.

### Shiny

The [Building Shiny Web Apps in R](r-shiny.html) lesson requires installation of several R packages in addition to those mentioned above:

```r
install.packages("shiny")
install.packages("shinythemes")
install.packages("lubridate")
```

To check that these are correctly installed, first close RStudio and then reopen it and run the following:

```r
library(shiny)
library(shinythemes)
library(lubridate)
```

These commands may produce some notes or other output, but as long as they work without an error message, you're good to go. If you get a message that says something like: `Error in library(packageName) : there is no package called 'packageName'`, then the required packages did not install correctly. Please do not hesitate to [email me](people.html) _prior to the course_ if you are still having difficulty.


## Get Data

The data used in any of these classes can be found at the [data](data.html) link on the navbar at the top. Create a new folder somewhere on your computer that's easy to get to (e.g., your Desktop). Name it `bioconnector`. Inside that folder, make a folder called `data`, all lowercase. Download datasets as needed by [clicking here](data.html) or using the link at the top. Save these data files to the new `bioconnector/data` folder you just made.


## RNA-seq

**Software setup:** Follow instructions above for [R+RStudio+Packages](#r) and [Bioconductor](#bioconductor). See the sections above for full instructions and troubleshooting tips, but in summary, after installing R+RStudio, you'll need the tidyverse, Bioconductor core, and DESeq2 packages. 

```r
# tidyverse pkg installs dplyr, tibble, tidyr, ggplot2, readr, etc.
install.packages("tidyverse")
# Install Bioconductor core packages and DESeq2
source("http://bioconductor.org/biocLite.R")
biocLite()
biocLite("DESeq2")
```

**Download data we'll use in class.** Create a new folder somewhere on your computer that's easy to get to (e.g., your Desktop). Name it `bioconnector`. Inside that folder, make a folder called `data`, all lowercase. Download the 3 data files below, saving them to the new `bioconnector/data` folder you just made.

1. Count matrix (i.e., `countData`): [airway_rawcounts.csv](data/airway_rawcounts.csv)
1. Sample metadata (i.e., `colData`): [airway_metadata.csv](data/airway_metadata.csv)
1. Gene Annotation data: [annotables_grch37.csv](data/annotables_grch37.csv)

**Prerequisites!** This is _not_ an introductory R class. This class assumes you're comfortable working in R, using ggplot2 for visualization, and using dplyr verbs and the **`%>%`** for chaining together multiple operations. Work through the workshop materials below if you need a refresher.

- [R basics](r-basics.html)
- [Data frames](r-dataframes.html)
- [Manipulating data with dplyr and `%>%`](r-dplyr.html) (also, work through the [dplyr vignette](https://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html))
- [Tidy data & advanced manipulation](r-tidy.html)
- [Data Visualization with ggplot2](r-viz-gapminder.html)

**Recommended reading** prior to class:

1. Conesa et al. A survey of best practices for RNA-seq data analysis. [Genome Biology 17:13 (2016)](http://genomebiology.biomedcentral.com/articles/10.1186/s13059-016-0881-8).  
    - _This is a good all-purpose review on RNA-seq analysis_.
1. Himes et al. "RNA-Seq transcriptome profiling identifies CRISPLD2 as a glucocorticoid responsive gene that modulates cytokine function in airway smooth muscle cells." [PLoS ONE 9.6 (2014): e99625](http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0099625). 
    - _The data we'll use comes from this publication_.
1. Soneson et al. "Differential analyses for RNA-seq: transcript-level estimates improve gene-level inferences." [F1000Research 4 (2015)](http://f1000research.com/articles/4-1521/v1). 
    - _This paper describes more recently developed approaches for gene-level analysis using transcript-level quantification, which is probably more accurate than the approach we're using here_.

## Survival Analysis

_Stay tuned..._

----

----
