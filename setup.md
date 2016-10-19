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
    - Even if you've installed these packages in the past, go ahead and re-install the most recent version. Many of these packages are updated often, and we may use new features in the workshop that aren't available in older versions.
    - At any point (especially if you've used R/Bioconductor in the past), R may ask you if you want to update any old packages by asking `Update all/some/none? [a/s/n]:`. If you see this, type **`a`** at the propt and hit `Enter` to update any old packages. 
    - If you see a note long the lines of "_binary version available but the source version is later_", followed by a question, "_Do you want to install from sources the package which needs compilation? y/n_", type **`n`** for no, and hit enter.
    - If you're using a Windows machine you might get some errors about not having permission to modify the existing libraries -- don't worry about this message. You can avoid this error altogether by running RStudio as an administrator (right click the RStudio icon, then click "run as administrator").

[^rversion]: R version 3.1.2 was released October 2014. If you have not updated your R installation since then, you need to upgrade to a more recent version, since several of the required packages depend on a version at least this recent. You can check your R version with the `sessionInfo()` command.

```r
install.packages("tidyverse")
install.packages("knitr")
install.packages("rmarkdown")
```

You can check that you've installed everything correctly by closing and reopening RStudio and entering the following commands at the console window (don't worry about the _Conflicts with tidy packages_ warning):

```r
library(tidyverse)
library(knitr)
library(rmarkdown)
```

These commands may produce some notes or other output, but as long as they work without an error message, you're good to go. If you get a message that says something like: `Error in library(packageName) : there is no package called 'packageName'`, then the required packages did not install correctly. Please do not hesitate to [email me](people.html) _prior to the course_ if you are still having difficulty.

### Bioconductor

Additionally, you'll need to install a few [Bioconductor](http://bioconductor.org/) packages. These packages are installed differently than "regular" R packages from CRAN. Copy and paste these lines of code into your R console.

```r
source("http://bioconductor.org/biocLite.R")
biocLite()
biocLite("DESeq2")
```

You can check that you've installed everything correctly by closing and reopening RStudio and entering the following commands at the console window:

```r
library(DESeq2)
```

If you get a message that says something like: `Error in library(packageName) : there is no package called 'packageName'`, then the required packages did not install correctly. Please do not hesitate to [email me](people.html) _prior to the course_ if you are still having difficulty.


### RMarkdown

First, install R and RStudio as described above. Several additional setup steps required for the reproducible research with RMarkdown class.

1. First, launch RStudio (not R). Click File, New File, R Markdown. This may tell you that you need to install additional packages (`knitr`, `yaml`, `htmltools`, `caTools`, `bitops`, and `rmarkdown`). Click "Yes" to install these.
1. Sign up for a free account at **[RPubs.com](http://rpubs.com/)**.
1. If you want to convert to PDF, you will need to install a **LaTeX** typesetting engine. This differs on Mac and Windows. **Note that this part of the installation may take up to several hours, and isn't strictly required for the class.**
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

## [Get Data](data.html)

1. **Create a new folder** somewhere on your computer that's easy to get to (e.g., your Desktop). Name it `bioconnector`. Inside that folder, make a folder called `data`, all lowercase. 
1. **Download datasets as needed** by [clicking here](data.html) or using the link at the top. Save these data files to the new `bioconnector/data` folder you just made.

