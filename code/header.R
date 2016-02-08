# loading necessary libraries
library('rjson')
library('memisc')
library('gdata')

# loading survey and response data
survey <- fromJSON(file='data/sample.qsf')
responses <- as.data.set(spss.system.file('data/sample.sav'))
