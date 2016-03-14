### Importing Results
Importing from SPSS data

    install.packages('memisc')
    library('memisc')
    data <- as.data.set(spss.system.file('sample.sav')

I had some trouble importing the SPSS, and consulted this [stackoverflow thread](https://stackoverflow.com/questions/3136293/read-spss-file-into-r) which recommended that I use the String Width = Short option in [this response](http://stackoverflow.com/a/4415043/3161979). That worked for me.

I was asked how we'd determine the question type, that's contained in the qsf file that Qualtrics provides:

    > qsf$SurveyElements[[8]]$Payload$QuestionType
    [1] "MC"

``"MC"`` represents "Multiple Choice" here.
