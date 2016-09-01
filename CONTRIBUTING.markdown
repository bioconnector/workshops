# Contributing

This repository contains all the source code used to build [bioconnector.org/workshops](http://bioconnector.org/workshops) using RStudio to render a collection of RMarkdown files as a standalone website. This requires RMarkdown >=v0.9.6, and optionally, the RStudio IDE preview, which has integrated support for building websites (i.e., a "Build Website" button that does it all).

To contribute:

1. First read the documentation for Rmarkdown websites: <http://rmarkdown.rstudio.com/rmarkdown_websites.html>.
1. Review the information below.
1. Use either `rmarkdown::clean_site()` or the button in RStudio to completely wipe any rendered output.
1. Use either ``rmarkdown::render_site()`` or the button in RStudio to build the website. Ensure no errors or warnings are present in the build pane.
1. `git pull`, `git push` to your remote, then submit a pull request to the master branch of this repo.


### Authoring

All lessons are stored as individual **.Rmd** files in the root directory of the site. Building the website with the "Build Website" button in RStudio or using `rmarkdown::render_site()` at the console will render all the **.md** and **.Rmd** into a single output directory (`_site/`). Any other files except those starting with `_` are also copied into the `_site/` directory. This is how data, images, css, etc. are included in the rendered site.

### Deploying

_There's really no need to worry about this -- only the master maintainer (Stephen, right now) will ever push/deploy. **TL;DR**: gitignore the built `_site/` directory, commit all your changes to master, and Stephen will deploy the `_site/` directory to the gh-pages branch._

The master branch of this repo tracks all source files and rendered output. The rendered `_site/` directory is not tracked on master, and is deployed to the `gh-pages` branch using [ghp-import](https://github.com/stephenturner/ghp-import). Commit all changes and push the repo to the master branch then run `ghp-import` on the `_site/` directory. As stated in the docs:

> Inside your repository just run ghp-import $DOCS_DIR where $DOCS_DIR is the path to the built documentation. This will write a commit to your gh-pages branch with the current documents in it.
>
> If you specify -p it will also attempt to push the gh-pages branch to GitHub. By default it'll just run `git push origin gh-pages`. You can specify a different remote using the -r flag.
>
> You can specify a different branch with -b. This is useful for user and organization page, which are served from the master branch.

So, the command to do this here, leaving a commit message with a timestamp, would be:

```sh
ghp-import -p -n -m "$(date)" _site
```

This is simplified by providing the [_deploy.sh](_deploy.sh) script.


### Data

All data used in this repo is stored in the `data/` directory. All you should have to do to is drop the data you need into this directory. The `data.Rmd` file when rendered will create a page giving direct links to all the files stored in the `data/` directory, with the exception of files ending in .html (e.g., index.html). In case someone were to navigate directly to the `data/` folder instead of the `data.html`, I created an index.html file for convenience using [this script](https://github.com/stephenturner/devnotes/blob/master/scripts/makeindex.sh). Avoid committing large files to the data directory -- host them somewhere else if they're more than a few megabytes.

### Other info/tips/gotchas

- The site's configuration is controlled by `_site.yml`. See the [RMarkdown websites documentation](http://rmarkdown.rstudio.com/rmarkdown_websites.html) for more information. The navigation bar is controlled by this file, as well as various output parameters. I'm using icons from [Font Awesome](http://fontawesome.io/) reading in the CSS from a CDN.
- Note that the `exclude` list in `_site.yml` will _not_ stop .md or .Rmd files from being rendered. You can disable rendering of a .md/.Rmd by renaming it with a preceding `_`.
- I wanted README and CONTRIBUTING files in the repo, using markdown formatting such that they're rendered nicely on GitHub, but I didn't want these files to be rendered as HTML to the resulting output directory. GitHub will render files ending in `.markdown`, but these files are not rendered by RMarkdown/RStudio. These files are also excluded in the `_site.yml` config.
- I recommend setting `knitr::opts_chunk$set(cache=TRUE)` in the global options for each .Rmd file. Every little bit helps when rendering many files after cleaning.
- Put any helpful resources in [help.md](help.md).
- Put any setup instructions under the appropriate level 2 or level 3 heading in [setup.md](setup.md).
- Headings: Use ## and ### for major and minor headings, respectively. Try to avoid long headings as much as possible to try to avoid word wrapping in the floating TOC.
- If you create a page with no headings, you need to remove the toc from the page. See the source for [index.md](index.md):

    ```
    ---
    title: "Page Title"
    output:
      html_document:
        toc: false
    ---
    ```
-

### Packages required to build

The material on the site covers a variety of topics and lessons, many of which require specific R packages. To properly build and deploy the site you'll need all packages installed:

```r
# CRAN packages
install.packages("dplyr")
install.packages("ggplot2")
install.packages("tidyr")
install.packages("readr")
install.packages("stringr")
install.packages("knitr")
install.packages("rmarkdown")
install.packages("highcharter")
install.packages("d3heatmap")
install.packages("leaflet")
install.packages("visNetwork")
install.packages("jsonlite")
install.packages("shiny")
install.packages("shinythemes")
install.packages("lubridate")

# Bioconductor
source("http://bioconductor.org/biocLite.R")
biocLite()
biocLite("DESeq2")
```

If you want to optionally demonstrate something without strictly requiring the package to build the site, you could duplicate a chunk, echoing but not evaluating the first, and evaluating but not echoing the second, where you check to see if the package is installed in the second. For example, as used in the intro stats lesson, optionally show how _if_ you have Tmisc installed, you can plot and tabulate missing data, but if you don't have Tmisc, the site build won't fail (you just won't see the output):


    ```{r tmisc_noeval, eval=FALSE}
    # Install if you don't have it already
    # install.packages("Tmisc")
    library(Tmisc)
    gg_na(nh)
    propmiss(nh)
    ```

    ```{r tmisc_noecho, echo=FALSE, results="markup"}
    if (requireNamespace("Tmisc", quietly = TRUE)) Tmisc::gg_na(nh)
    if (requireNamespace("Tmisc", quietly = TRUE)) Tmisc::propmiss(nh)
    ```

