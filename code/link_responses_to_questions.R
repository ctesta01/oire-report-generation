# Load Header and Run Questions
if(!exists("survey", mode="any")) source("header.R")
if(!exists("questions", mode="any")) source("questions.R")

# Linking Responses to Questions
# INCOMPLETE
for (i in questions) {
  i$Responses <- list()
  question_tag <- paste(
    i$Payload$DataExportTag,
    "_"
    )
  matching_responses <- which(
    startsWith(names(responses), question_tag) |
    names(responses) == i$Payload$DataExportTag
    )
  for (k in matching_responses) {
    index = length(i$Responses) + 1
    i$Responses[index] <- responses[k]
  }
}
