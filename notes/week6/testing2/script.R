library('knitr')
knit('report.rnw', output = 'latex/report.tex')
setwd('./latex')
tools::texi2pdf('report.tex', clean = TRUE)
