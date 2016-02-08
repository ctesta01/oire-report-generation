# Load Header File
if(!exists("survey", mode="any")) source("header.R")

# Building "questions"
# the questions object is a copy
# of the survey$SurveyElements object, but then
# all non-question elements are removed
questions <- survey$SurveyElements
for (i in (length(questions) - 1):1) {
  if (questions[[i]]$Element != "SQ") {
    questions[[i]] <- NULL
  }
}
