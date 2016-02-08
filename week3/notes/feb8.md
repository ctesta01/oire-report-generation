We'd like to use the CSV response data over the SPSS
response data because data cleaning is currently done
in the CSV file with Excel.

    if(!exists("survey", mode="any")) source("header.R")

This code snippet will work similarly to `require()` for
loading local scripts.

`code/header.R` will contain the code to import the
necessary libraries for the project, and any
project-wide data that should be imported from the
`code/data` folder.

`code/questions.R` will contain the code to create the
questions object which be the primary object referenced
by knitr to make the report.

    responses = read.csv('data/sample.csv', skip=2, header=F)
    responses2 = read.csv('data/sample.csv')
    names(responses) = names(responses2)
    rm(responses2)

The above code might look a little funny. It's there to
skip the second row of the CSV file. 
