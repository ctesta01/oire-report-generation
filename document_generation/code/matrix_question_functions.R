# Returns an array of questions that are single answer matrix questions
is_matrix_single_answer_question <- function(x) {
  return(x$Payload$QuestionType == "Matrix" &&
  x$Payload$SubSelector == "SingleAnswer")
}

# A saved list of indexes of the single answer matrix questions
matrix_single_answer_questions <- which(sapply(questions,
  is_matrix_single_answer_question))

# Returns an array of the valid responses for each matrix question component
# (the "answers")
matrix_get_respondents_count <- function(x) {
  if (x$Payload$Selector == "Likert" &&
  x$Payload$SubSelector == "SingleAnswer"){
    respondents_count <- sapply(x$Responses, function(y) strtoi(length(y != -99)))
    return(respondents_count)
  } else if (x$Payload$Selector == "Likert" &&
  x$Payload$SubSelector == "MultipleAnswer"){
    respondents_count <- sapply(x$Responses, length)
    return(respondents_count)
  } else if (x$Payload$Selector == "Bipolar"){
    respondents_count <- sapply(x$Responses, function(y) strtoi(length(y != -99)))
    return(respondents_count)
  } else if (x$Payload$Selector == "Likert" &&
  x$Payload$SubSelector == "DL"){
    respondents_count <- sapply(x$Responses, function(y) strtoi(length(y != -99)))
    return(respondents_count)
  }
}

# Returns an array with the question components as rows and
# the response choices as columns
matrix_factor_choices_by_answers <- function(x) {
choices_by_answers <- t(sapply(x$Responses, function(y)
table(factor(y, x$Payload$AnswerOrder))))
rownames(choices_by_answers) <- sapply(x$Payload$Choices, function(y) y$Display)
colnames(choices_by_answers) <- sapply(x$Payload$Answers, function(y) y$Display)
return(choices_by_answers)
}

# Takes the response data and turns it into percents based on the valid
# responses
matrix_single_answer_get_results <- function(x) {
  array <- matrix_factor_choices_by_answers(x)
  for (i in 1:nrow(array)) {
  for (j in 1:ncol(array)) {
  array[i,j] <- percent(strtoi(array[i,j]) /
  matrix_get_respondents_count(x)[i])
  }
  }
  array <- cbind(array, N=matrix_get_respondents_count(x))
  array <- cbind(sapply(x$Payload$Choices, function(y) y$Display), array)
}

# Loops through all the matrix single answer questions and generates the
# table and kable code.
for (i in matrix_single_answer_questions) {
  questions[[i]]$Table = matrix_single_answer_get_results(questions[[i]])
  questions[[i]]$Kable = kable(questions[[i]]$Table, format='latex',
  row.names = FALSE)
}
