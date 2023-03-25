load: /home/rstudio/R/load.R
	Rscript /home/rstudio/R/load.R "/home/rstudio/data/0007.txt" "/home/rstudio/data/0107.txt" "/home/rstudio/data/0207.txt" "/home/rstudio/data/0307.txt" "/home/rstudio/data/0008.txt" "/home/rstudio/data/0108.txt" "/home/rstudio/data/0208.txt" "/home/rstudio/data/0308.txt" "/home/rstudio/data/data2007_not_cleaned.txt" "/home/rstudio/data/data2008_not_cleaned.txt"

tidy: /home/rstudio/R/tidy.R
	Rscript /home/rstudio/R/tidy.R "/home/rstudio/data/data2007_not_cleaned.txt" "/home/rstudio/data/data2008_not_cleaned.txt" "/home/rstudio/data/data2007_cleaned.txt" "/home/rstudio/data/data2008_cleaned.txt"

figures: /home/rstudio/R/figures.R
	Rscript /home/rstudio/R/figures.R "/home/rstudio/data/data2007_cleaned.txt" "/home/rstudio/data/data2008_cleaned.txt" "/home/rstudio/output/"
	
models: /home/rstudio/R/analysis.R
	Rscript /home/rstudio/R/analysis.R "/home/rstudio/data/data2007_cleaned.txt" "/home/rstudio/data/data2008_cleaned.txt" "/home/rstudio/output/"

render: /home/rstudio/analysis/analysis.Rmd
	Rscript -e "rmarkdown::render(input = '/home/rstudio/analysis/analysis.Rmd',output_format = 'html_document', output_dir = '/home/rstudio/analysis/', encoding = 'UTF-8')"

.PHONY: all
all:
	make load
	make tidy
	make figures
	make models
	make render

.PHONY: clean
clean:
	rm -f /home/rstudio/data/data2007_not_cleaned.txt /home/rstudio/data/data2008_not_cleaned.txt
	rm -f /home/rstudio/data/data2007_cleaned.txt /home/rstudio/data/data2008_cleaned.txt
	rm -f /home/rstudio/output/*.png
	rm -f /home/rstudio/output/*.csv
	rm -f /home/rstudio/analysis/*.html
	rm -f *.html
