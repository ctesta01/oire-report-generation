# loading necessary libraries
library('rjson')
library('memisc')
library('gdata')
library('knitr')
library('scales')
library('stringr') 


# loading survey and response data

surveyfile = file.choose()
responsesfile = file.choose()
survey = fromJSON(file=surveyfile)
responses = read.csv(responsesfile, skip=2, header=F)
responses2 = read.csv(responsesfile)
names(responses) = names(responses2)
rm(responses2)
