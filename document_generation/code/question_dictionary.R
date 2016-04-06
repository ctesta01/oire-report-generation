human_readable_qtype <- function (Question) {
  qtype = ""
  if (is_multiple_choice(Question)) {
    qtype = "Check All"
  } else if (is_single_answer(Question)) {
    qtype = "Single Answer"
  } else if (is_rank_order(Question)) {
    qtype = "Rank Order"
  } else if (is_text_entry(Question)) {
    qtype = "Text Entry"
  } else {
    qtype = ""
  }

  return(qtype)
}

### create_entry creates the row for any individual
# response with the following elements in it:
# "DataExportTag",
# "QuestionText",
# "QuestionType",
# "QuestionType2",
# "QuestionType3",
# "QuestionType4",
create_entry <- function(e, i, j) {
  return(c(
  # question number
  e,
  # data export tag
  Blocks[[i]]$BlockElements[[j]]$Payload$DataExportTag,
  # question text
  Blocks[[i]]$BlockElements[[j]]$Payload$QuestionText,
  # human readable question type
  human_readable_qtype(Blocks[[i]]$BlockElements[[j]]),
  # qualtrics question type
  Blocks[[i]]$BlockElements[[j]]$Payload$QuestionType,
  # qualtrics question selector
  Blocks[[i]]$BlockElements[[j]]$Payload$Selector,
  # qualtrics question subselector
  Blocks[[i]]$BlockElements[[j]]$Payload$SubSelector
  ))
}



### loop through each block, then each question,
# then of the columns of the responses,
# then each of the entries in each of the response columns,
# and create an entry using "create_entry"
entries = list()
e = 0
for (i in 1:length(Blocks)) {
  if (length(Blocks[[i]]$BlockElements) != 0) {
    for (j in 1:length(Blocks[[i]]$BlockElements)) {
      e = e + 1
      if (is.null(Blocks[[i]]$BlockElements[[j]]$Payload$SubSelector)) {
        Blocks[[i]]$BlockElements[[j]]$Payload$SubSelector <- ""
      }
      entries[[e]] <- create_entry(e, i, j)
    }
  }
}

# entries are turned into a data frame with the specified headers
question_dictionary <- list_of_rows_to_df(entries)
colnames(question_dictionary) <- c("QuestionNumber", "DataExportTag",
"QuestionText", "QuestionType", "QuestionType2",
"QuestionType3", "QuestionType4")

# row.names=FALSE is so we don't get that stupid 1,2,3,... in the first column.
write.csv(question_dictionary, 'output/question_dictionary.csv', row.names=FALSE)
