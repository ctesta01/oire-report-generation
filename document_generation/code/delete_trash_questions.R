# Load Header and Run Questions
if(!exists("survey", mode="any")) source("header.R")
if(!exists("questions", mode="any")) source("questions.R")

# Get the Block element from the survey$SurveyElements list
Blocks <- Filter(function(x) x$Element == "BL", survey$SurveyElements)

# As far as I can tell, there's only one Block element in the
# survey$SurveyElements list. In that Block element, there's multiple
# payloads. So here I'm checking for which payload of the payloads in
# the single Block element found have the type "Trash"

# NOTE: It might not be true that there's only one Block element, if there
# are more, this will have to be re-done.
Trash <- Filter(function(x) x$Type == "Trash", Blocks[[1]]$Payload)
TrashQuestions <- list()
for (i in Trash[[1]]$BlockElements) {
  TrashQuestions <- c(i$QuestionID, TrashQuestions)
}

delete_if_in_trash <- function(x) if (x$Payload$QuestionID %in% TrashQuestions) {
  return(NULL)
  } else {
    return(x)
  }

# replace any questions that are in the trash with NULL in the questions list
# and then delete all the questions equal to NULL
questions <- lapply(questions, delete_if_in_trash)
questions <- Filter(Negate(function(x) is.null(unlist(x))), questions)

# clearing out the variables we don't need anymore
rm(delete_if_in_trash)
rm(Trash)
rm(TrashQuestions)

Blocks[[1]]$Payload[which(sapply(Blocks[[1]]$Payload, function(x) x$Type
== "Trash"))] = NULL
