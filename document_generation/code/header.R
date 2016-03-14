# loading necessary libraries
if(!require(rjson)) { install.packages('rjson') }
if(!require(gdata)) { install.packages('gdata') }
if(!require(knitr)) { install.packages('knitr') }
if(!require(stringr)) { install.packages('stringr') }
suppressMessages(library('rjson'))
suppressMessages(library('gdata'))
suppressMessages(library('knitr'))
suppressMessages(library('stringr'))

if(.Platform$OS.type == "windows") {
  if(!require(installr)) {
    install.packages("installr");
    require(installr)
  }
  install.pandoc()
}

# loading survey and response data
print("Select Qualtrics Survey File:")
surveyfile = file.choose()
print("Select CSV Response File:")
responsesfile = file.choose()
survey = fromJSON(file=surveyfile)
responses = read.csv(responsesfile, skip=2, header=F)
responses2 = read.csv(responsesfile)
names(responses) = names(responses2)
rm(responses2)

# some functions for later use
percent <- function(x, digits = 1, format = "f", ...) {
  paste0(formatC(100 * x, format = format, digits = digits, ...), "%")
}
