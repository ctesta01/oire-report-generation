# Load Header File
if(!exists("survey", mode="any")) source("header.R")

# Clean HTML out of question text
# This function will be called later when we're looping
# through the questions to clean the question text of any
# html tags.
cleanHTML <- function(htmlString) {
  return(
    str_replace_all(
    gsub("&nbsp;", " ",
    gsub("<.*?>", "", htmlString)),
    "[^[:alnum:].,?:;=-] ", ""))
}

# Building "questions"
# the questions object is a copy
# of the survey$SurveyElements object, but then
# all non-question elements are removed.
# For all questions, the question text has HTML tags
# stripped out.
questions <- survey$SurveyElements
for (i in length(questions):1) {
  if (questions[[i]]$Element != "SQ") {
    questions[[i]] <- NULL
  } else {
    questions[[i]]$Payload$QuestionText = cleanHTML(questions[[i]]$Payload$QuestionText)
  }
}
