# Load Header and Run Questions
if(!exists("survey", mode="any")) source("header.R")
if(!exists("questions", mode="any")) source("questions.R")

# Linking Responses to Questions
# For each question, construct a question_tag prefix which is
# it's DataExportTag + "_". For example "Q1.6" -> "Q1.6_"
# Then link responses that start with a column name that is
# either exactly the DataExportTag or start with the question_tag prefix.
# Then we build a data-frame of the matching_responses and insert
# into each question under Responses.
for (i in 1:length(questions)) {
  question_tag <- paste(
    questions[[i]]$Payload$DataExportTag,
    "_",
    sep=""
    )
  matching_responses <- which(
    startsWith(names(responses), question_tag) |
    names(responses) == questions[[i]]$Payload$DataExportTag
    )
  questions[[i]]$Responses <- as.data.frame(responses[matching_responses])
  rm(question_tag)
}
