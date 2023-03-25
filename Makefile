load: /home/rstudio/R/load.R
	Rscript /home/rstudio/R/load.R "/home/rstudio/data/0007.txt" "/home/rstudio/data/0107.txt" "/home/rstudio/data/0207.txt" "/home/rstudio/data/0307.txt" "/home/rstudio/data/0008.txt" "/home/rstudio/data/0108.txt" "/home/rstudio/data/0208.txt" "/home/rstudio/data/0308.txt" "/home/rstudio/data/data2007_not_cleaned.txt" "/home/rstudio/data/data2008_not_cleaned.txt"

tidy: /home/rstudio/R/tidy.R
	Rscript /home/rstudio/R/tidy.R "/home/rstudio/data/data2007_not_cleaned.txt" "/home/rstudio/data/data2008_not_cleaned.txt" "/home/rstudio/data/data2007_cleaned.txt" "/home/rstudio/data/data2008_cleaned.txt"

figures: /home/rstudio/R/figures.R
	Rscript /home/rstudio/R/figures.R "/home/rstudio/data/data2007_cleaned.txt" "/home/rstudio/data/data2008_cleaned.txt" "/home/rstudio/output/"
	
analysis: /home/rstudio/R/analysis.R
	Rscript /home/rstudio/R/analysis.R "/home/rstudio/data/data2007_cleaned.txt" "/home/rstudio/data/data2008_cleaned.txt" "/home/rstudio/output/"

.PHONY: all
all:
	make load
	make tidy
	make figures
	make analysis

.PHONY: clean
clean:
	rm -f /home/rstudio/data/data2007_not_cleaned.txt /home/rstudio/data/data2008_not_cleaned.txt
	rm -f /home/rstudio/data/data2007_cleaned.txt /home/rstudio/data/data2008_cleaned.txt
	rm -f /home/rstudio/output/*.png
	rm -f /home/rstudio/output/*.csv
	rm -f /home/rstudio/analysis/*.html 

