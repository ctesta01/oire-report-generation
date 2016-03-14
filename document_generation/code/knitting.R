knit('report.rnw', output = 'output/report.tex')
setwd('./output')
tools::texi2pdf('report.tex', clean = TRUE)
setwd('..')
