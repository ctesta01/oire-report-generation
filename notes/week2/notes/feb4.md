### Loading Resources
    # loading necessary libraries
    library('rjson')
    library('memisc')
    library('gdata')

    # loading survey and response data
    survey <- fromJSON(file='sample.qsf')
    responses <- as.data.set(spss.system.file('sample.sav'))

    # building the questions object
    #   the questions object is built first as a copy
    #   of the survey$SurveyElements object, but then
    #   all non-question elements are removed
    questions <- survey$SurveyElements
    for (i in (length(questions) - 1):1) {
      if (questions[[i]]$Element != "SQ") {
        questions[[i]] <- NULL
      }
    }

    # starting the Report
    report <- list()
    j <- 1
    for (i in questions) {
      report$questions[[j]] <- i$Payload
      j = j + 1
    }


    ### DOESN'T WORK YET
    ### Trying to match responses into the report object
    j <- 1
    for (i in report$questions) {
      question_tag <- paste(
        tolower(i$Payload$DataExportTag),
        "_",
        sep="")
        #_
      i$Responses <- list()
      matching_responses <- which(startsWith(names(responses), question_tag))
      for (k in matching_responses) {
        i$Responses[[j]] <- responses[[k]]
      }
      j <- 1
    }








#### Libraries
`rjson` is used to load the survey file (the .qsf file which is in json format)

`memisc` is used to load the spss file ('sample.sav')

`gdata` is used for the startsWith function later used to match
