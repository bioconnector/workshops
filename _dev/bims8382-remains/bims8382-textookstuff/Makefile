all: clean textbook

.PHONY: clean

clean:
	rm bioconnector.pdf

textbook: bookpreface.md setup.md r-basics.md r-dplyr.md r-tidy.md r-ggplot2.md r-repres.md r-rnaseq-airway.md help.md
	cat $^ > textbook.md
	pandoc --toc -s -V geometry:margin=1in -V documentclass:report -V fontsize=12pt textbook.md -o textbook.pdf
	open textbook.pdf