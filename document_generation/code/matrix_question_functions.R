is_matrix_question <- function(x) {
  return(x$Payload$QuestionType == "Matrix")
}

matrix_questions <- which(sapply(questions, is_matrix_question))

matrix_get_respondents_count <- function(x) {
  if (x$Payload$Selector == "Likert" &&
  x$Payload$SubSelector == "SingleAnswer"){
    respondents_count <- sapply(x$Responses, function(y) length(y != -99))
    return(respondents_count)
  } else if (x$Payload$Selector == "Likert" &&
  x$Payload$SubSelector == "MultipleAnswer"){
    respondents_count <- sapply(x$Responses, length)
    return(respondents_count)
  } else if (x$Payload$Selector == "Bipolar"){
    respondents_count <- sapply(x$Responses, function(y) length(y != -99))
    return(respondents_count)
  } else if (x$Payload$Selector == "Likert" &&
  x$Payload$SubSelector == "DL"){
    respondents_count <- sapply(x$Responses, function(y) length(y != -99))
    return(respondents_count)
  }
}
