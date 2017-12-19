---
title: Reproducible Research
# date: Spring 2017
author: "[bioconnector.org/workshops/r-rmarkdown](http://bioconnector.org/workshops/r-rmarkdown)"
output:
  pdf_document:
    fig_caption: yes
---

# Who cares about reproducible research?

Science is plagued by reproducibility problems. Especially genomics!

- Scientists in the United States spend [$28 billion](http://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.1002165) each year on basic biomedical research that cannot be repeated successfully.[^spending]
- A reproducibility study in psychology found that only [39 of 100 studies could be reproduced](http://www.nature.com/news/first-results-from-psychology-s-largest-reproducibility-test-1.17433).[^psych]
- The Journal _Nature_ on the [issue of reproducibility](http://www.nature.com/news/reproducibility-1.17552):[^natureonrep]
    - "_Nature_ and the Nature research journals will introduce editorial measures to address the problem by improving the consistency and quality of reporting in life-sciences articles... **we will give more space to methods sections. We will examine statistics more closely and encourage authors to be transparent, for example by including their raw data.**"
    - _Nature_ also released a [checklist](http://www.nature.com/authors/policies/checklist.pdf), unfortunately with _wimpy_ computational check _(see #18)_.
- On microarray reproducibility:[^microarrayrep]
    - 18 Nat. Genet. microarray experiments
    - Less than 50% reproducible
    - Problems:
        - Missing data (38%)
        - Missing software/hardware details (50%)
        - Missing method/processing details (66%)
- NGS: run-of-the-mill variant calling (align, process, call variants):[^ngsrep]
    - 299 articles published in 2011 citing the 1000 Genomes project pilot publication
    - Only 19 were NGS studies with similar design
    - Only 10 used tools recommended by 1000G.
    - Only 4 used full 1000G workflow (realignment & quality score recalibration).

[^spending]: Freedman, et al. "The economics of reproducibility in preclinical research." _PLoS Biol_ 13.6 (2015): e1002165.
[^psych]: <http://www.nature.com/news/first-results-from-psychology-s-largest-reproducibility-test-1.17433>
[^natureonrep]: <http://www.nature.com/news/reproducibility-1.17552>
[^microarrayrep]: Ioannidis, et al. "Repeatability of published microarray gene expression analyses." _Nature genetics_ 41.2 (2009): 149-155.
[^ngsrep]: Nekrutenko, et al. "Next-generation sequencing data interpretation: enhancing reproducibility and accessibility." _Nature Reviews Genetics_ 13.9 (2012): 667-672.

Consider the figure below. How do we reproduce it? What do we need?

![Life expectancy vs GDP by Continent. See bioconnector.org/workshops/r-viz-gapminder.](../img/gm-lifeexp-vs-gdp.png)

- The **[data](https://github.com/bioconnector/bioconnector.github.io/blob/master/data/gapminder.csv)**:
    - Data points themselves
    - Other metadata
- The **[code](https://raw.githubusercontent.com/bioconnector/workshops/master/lessons/r/r-viz.Rmd)**:
    - Should be readable
    - Comments in the code / well-documented so a normal person can figure out how it runs.
    - How were the trend lines drawn?
    - What version of software / packages were used?

This kind of information is rarely available in scientific publications, but it's now extraordinarly easy to put this kind of information on the web.

Could I replicate Figure 1 from your last publication? If not, what would _you and your co-authors_ need to provide or do so I could replicate Figure 1 from your last publication?

### As scientists we should aim for _robust_ and _reproducible_ research.

- "**Robust research** is about doing small things that stack the deck in your favor to prevent mistakes." _-Vince Buffalo, author of Bioinformatics Data Skills (2015)_.
- **Reproducible research** can be repeated by other researchers with the same results.

# Reproducibility is hard!

1. Genomics data is too large and high dimensional to easily inspect or visualize. Workflows involve multiple steps and it's hard to inspect every step.
1. Unlike in the wet lab, we don't always know what to expect of our genomics data analysis.
1. It can be hard to distinguish *good* from *bad* results.
1. Scientific code is usually only run once to generate results for a publication, and is more likely to contain silent bugs. (code that may produces unknowingly incorrect output rather than stopping with an error message).

# What's in it for _you?_

Yeah, it takes a lot of effort to be robust and reproducible.  However, *it will make your life (and science) easier!*

- Most likely, you will have to re-run your analysis more than once.
- In the future, you or a collaborator may have to re-visit part of the project.
- Your most likely collaborator is your future self, and your past self doesn't answer emails.
- You can make modularized parts of the project into re-useable tools for the future.
- Reproducibility makes you easier to work and collaborate with.

# Some recommendations for reproducible research

1. **Write code for humans, write data for computers.**
    - Code should be broken down into small chunks that may be re-used.
    - Make names/variables consistent, distinctive and meaningful.
    - Adopt a [style](http://adv-r.had.co.nz/Style.html) be consistent.[^style]
    - Write concise and clear comments.
1. **Make incremental changes.** Work in small steps with frequent feedback. Use version control. See <http://swcarpentry.github.io/git-novice/> for resources on version control.
1. **Make assertions and be loud, in code and in your methods.** Add tests in your code to make sure it's doing what you expect. See <http://software-carpentry.org/v4/test/> for resources on testing code.
1. **Use existing libraries (packages) whenever possible.** Don't reinvent the wheel. Use functions that have already been developed and tested by others.
1. **Prevent catastrophe and help reproducibility by making your data _read-only_.** Rather than modifying your original data directly, always use a workflow that reads in data, processes/modifies, then writes out intermediate and final files as necessary.
1. **Encapsulate the full project into one directory that is supported with version control.** See: Noble, William Stafford. "A quick guide to organizing computational biology projects." [_PLoS Comput Biol_ 5.7 (2009): e1000424](http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1000424).
1. **Release your code and data.** Simple. Without your code and data, your research is not reproducible.
    - GitHub (<https://github.com/>) is a great place for storing, distributing, collaborating, and version-controlling code.
    - RPubs (<http://rpubs.com/>) allows you to share dynamic documents you write in RStudio online.
    - Figshare (<http://figshare.com/>) and Zenodo (<https://zenodo.org/>) allow you to upload any kind of research output, publishable or not, free and unlimited. Instantly get permanently available, citable DOI for your research output.
    - _"Data/code is available upon request"_ or _"Data/code is available at the lab's website"_ are completely unacceptable in the 21st century.
1. **Write code that uses relative paths.**
    - Don't use hard-coded absolute paths (i.e. `/Users/stephen/Data/seq-data.csv` or `C:\Stephen\Documents\Data\Project1\data.txt`).
    - Put the data in the project directory and reference it _relative_ to where the code is, e.g., `data/gapminder.csv`, etc.
1. **Always set your seed.** If you're doing anything that involves random/monte-carlo approaches, always use `set.seed()`.
1. **Document everything and use code as documentation.**
    - Document why you do something, not mechanics.
    - Document your methods and workflows.
    - Document the origin of all data in your project directory.
    - Document **when** and **how** you downloaded the data.
    - Record **data** version info.
    - Record **software** version info with `session_info()`.
    - Use dynamic documentation to make your life easier.

[^style]: <http://adv-r.had.co.nz/Style.html>

# Useful references

Wilson, et al. **"Best practices for scientific computing."** [_PLoS Biol_ 12.1:e1001745 (2014)](http://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.1001745).

\scriptsize

> Scientists spend an increasing amount of time building and using software. However, most scientists are never taught how to do this efficiently. As a result, many are unaware of tools and practices that would allow them to write more reliable and maintainable code with less effort. We describe a set of best practices for scientific software development that have solid foundations in research and experience, and that improve scientists' productivity and the reliability of their software.

\normalsize

Wilson, et al. **"Good Enough Practices in Scientific Computing."** [_arXiv_ 609.00037 (2016)](https://arxiv.org/abs/1609.00037).

\scriptsize

> We present a set of computing tools and techniques that every researcher can and should adopt. These recommendations synthesize inspiration from our own work, from the experiences of the thousands of people who have taken part in Software Carpentry and Data Carpentry workshops over the past six years, and from a variety of other guides. Unlike some other guides, our recommendations are aimed specifically at people who are new to research computing.

\normalsize