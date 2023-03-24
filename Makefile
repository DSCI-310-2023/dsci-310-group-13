load: /home/rstudio/R/load.R
	Rscript /home/rstudio/R/load.R "/home/rstudio/data/0007.txt" "/home/rstudio/data/0107.txt" "/home/rstudio/data/0207.txt" "/home/rstudio/data/0307.txt" "/home/rstudio/data/0008.txt" "/home/rstudio/data/0108.txt" "/home/rstudio/data/0208.txt" "/home/rstudio/data/0308.txt" "/home/rstudio/data/data2007_not_cleaned.txt" "/home/rstudio/data/data2008_not_cleaned.txt"


.PHONY: clean
clean:
	rm -f /home/rstudio/data/data2007_not_cleaned.txt /home/rstudio/data/data2008_not_cleaned.txt
	rm -f *.html 
