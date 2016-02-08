# loading necessary libraries
library('rjson')
library('memisc')
library('gdata')

# loading survey and response data
survey <- fromJSON(file='data/sample.qsf')
responses <- read.csv('data/sample.csv')
