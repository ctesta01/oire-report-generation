# loading necessary libraries
library('rjson')
library('memisc')
library('gdata')

# loading survey and response data
survey = fromJSON(file='data/sample2.qsf')
responses = read.csv('data/sample2.csv', skip=2, header=F)
responses2 = read.csv('data/sample2.csv')
names(responses) = names(responses2)
rm(responses2)
