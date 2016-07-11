# Contributing

This repository contains all the source code used to build [bioconnector.org/workshops](http://bioconnector.org/workshops) using RStudio to render a collection of RMarkdown files as a standalone website. This requires RMarkdown >=v0.9.6, and optionally, the RStudio IDE preview, which has integrated support for building websites (i.e., a "Build Website" button that does it all).

To contribute:

1. First read the documentation for Rmarkdown websites: <http://rmarkdown.rstudio.com/rmarkdown_websites.html>.
1. Review the information below.
1. Use either `rmarkdown::clean_site()` or the button in RStudio to completely wipe any rendered output.
1. Use either ``rmarkdown::render_site()`` or the button in RStudio to build the website. Ensure no errors or warnings are present in the build pane.
1. `git pull`, `git push` to your remote, then submit a pull request to the master branch of this repo.


### Authoring and deploying

All lessons are stored as individual **.Rmd** files in the root directory of the site. Building the website with the "Build Website" button in RStudio or using `rmarkdown::render_site()` at the console will render all the **.md** and **.Rmd** into a single output directory (`_site/`). Any other files except those starting with `_` are also copied into the `_site/` directory. This is how data, images, css, etc. are included in the rendered site.

The master branch of this repo tracks all source files and rendered output. The rendered `_site/` directory is deployed as a subtree to the gh-pages branch using the [strategy outlined here](https://gist.github.com/cobyism/4730490). Briefly, you commit all changes and push the repo to the master branch. Then subtree push the `_site/` folder to origin/gh-pages.

```bash
git add .
git commit -m "commiting all changes"
git push origin master
git subtree push --prefix _site origin gh-pages
```

You can simplify the last bit by creating an alias in your .gitconfig so you only have to `git deploy` (this must be done from the root directory after committing/pushing changes to master).

```
[alias]
    deploy = subtree push --prefix _site origin gh-pages
```

### Data

All data used in this repo is stored in the `data/` directory. All you should have to do to is drop the data you need into this directory. The `data.Rmd` file when rendered will create a page giving direct links to all the files stored in the `data/` directory, with the exception of files ending in .html (e.g., index.html). In case someone were to navigate directly to the `data/` folder instead of the `data.html`, I created an index.html file for convenience using [this script](https://github.com/stephenturner/devnotes/blob/master/scripts/makeindex.sh). Avoid committing large files to the data directory -- host them somewhere else if they're more than a few megabytes.

### Other info/tips/gotchas

- The site's configuration is controlled by `_site.yml`. See the [RMarkdown websites documentation](http://rmarkdown.rstudio.com/rmarkdown_websites.html) for more information. The navigation bar is controlled by this file, as well as various output parameters. I'm using icons from [Font Awesome](http://fontawesome.io/) reading in the CSS from a CDN.
- Note that the `exclude` list in `_site.yml` will _not_ stop .md or .Rmd files from being rendered. You can disable rendering of a .md/.Rmd by renaming it with a preceding `_`.
- I wanted README and CONTRIBUTING files in the repo, using markdown formatting such that they're rendered nicely on GitHub, but I didn't want these files to be rendered as HTML to the resulting output directory. GitHub will render files ending in `.markdown`, but these files are not rendered by RMarkdown/RStudio. These files are also excluded in the `_site.yml` config.
- Review the [.gitignore](.gitignore) file. Specifically the part about ignoring output files in the root but not in the rendered directory. When using `cache=TRUE`, directories containing image outputs (`lessonName_files/`) are created in the root directory. These should be ignored by git. But you don't want to ignore the `*_files/` directories in the rendered output `_site/` directory, or else all your linked images would be broken. [This answer from SO](http://stackoverflow.com/questions/5533050/gitignore-exclude-folder-but-include-specific-subfolder) gives details about how to accomplish this in the .gitignore.
- I recommend setting `knitr::opts_chunk$set(cache=TRUE)` in the global options for each .Rmd file. Every little bit helps when rendering many files after cleaning.
- Put any helpful resources in [help.md](help.md).
- Put any setup instructions under the appropriate level 2 or level 3 heading in [setup.md](setup.md).

