#### Unused Questions
Something that needs to be dealt with is questions
that are in the trash or unused questions block.

It looks like if you can identify which block has
`$Payload[[2]]$Type == "Trash"`
that same element has   
`$Payload[[2]]$BlockElements[[1]]$QuestionID`
which is a list of question IDs that are in the trash.

    Blocks <- Filter(function(x) x$Element == "BL", survey$SurveyElements)

This code grabs our blocks.

    Trash <- Filter(function(x) x$Type == "Trash", Blocks[[1]]$Payload)

This gave me the Trash item from the blocks. I don't know if there will ever be more than one block element in a survey. I guess there might be.

So I suppose we should recurse through the blocks to check for multiple trashes?
For now, I'll just assume that there's only one block. Need to add a reminder
to come back and check on this.  

    TrashQuestions <- list()
    for (i in Trash[[1]]$BlockElements) {
      TrashQuestions <- c(i$QuestionID, TrashQuestions)
    }

    delete_if_in_trash <- function(x) if (x$Payload$QuestionID %in% TrashQuestions) {
      return(NULL)
      } else {
        return(x)
      }

    questions <- lapply(questions, delete_if_in_trash)
    questions <- Filter(Negate(function(x) is.null(unlist(x))), non_trash_questions)

This looks like it'll do the job. 
