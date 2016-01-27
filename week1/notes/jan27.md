Continuing with data modeling, we're starting to look at the survey elements and their structure.

    > for (i in 1:7) {
    + print(paste(json_data$SurveyElements[[i]]$Element, json_data$SurveyElements[[i]]$PrimaryAttribute, sep=": "))
    + }
    [1] "BL: Survey Blocks"
    [1] "FL: Survey Flow"
    [1] "SO: Survey Options"
    [1] "SCO: Scoring"
    [1] "STAT: Survey Statistics"
    [1] "QC: Survey Question Count"
    [1] "SQ: QID1"

- [knitr in a knutshell](http://kbroman.org/knitr_knutshell/)
This is a good set of examples/tutorials on knitr.
- [How to print a latex section title from the R code using knitr?](https://stackoverflow.com/questions/17992846/how-to-print-a-latex-section-title-from-the-r-code-using-knitr)
