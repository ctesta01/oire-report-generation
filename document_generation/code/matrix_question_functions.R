# Boolean function to determine if x is a
# single answer matrix questions
is_matrix_single_answer_question <- function(x) {
  return(x$Payload$QuestionType == "Matrix" &&
  (x$Payload$SubSelector == "SingleAnswer" ||
  x$Payload$SubSelector == "DL"))
}

is_matrix_bipolar_question <- function(x) {
  return(x$Payload$QuestionType == "Matrix" &&
  x$Payload$Selector == "Bipolar")
}

# Returns an array of questions that are multiple answer matrix questinos
is_matrix_multiple_answer_question <- function(x) {
  return(x$Payload$QuestionType == "Matrix" &&
  x$Payload$SubSelector == "MultipleAnswer")
}

# A saved list of indexes of the single answer matrix questions
matrix_single_answer_questions <- which(sapply(questions,
  is_matrix_single_answer_question))
matrix_bipolar_questions <- which(sapply(questions,
  is_matrix_bipolar_question))
matrix_multiple_answer_questions <- which(sapply(questions,
  is_matrix_multiple_answer_question))

# Returns an array of the valid responses for each matrix question component
# (the "answers")
matrix_get_respondents_count <- function(x) {
  if (x$Payload$Selector == "Likert" &&
  x$Payload$SubSelector == "SingleAnswer"){
    respondents_count <- sapply(x$Responses, function(y) strtoi(length(which(y != -99))))
    return(respondents_count)
  } else if (x$Payload$Selector == "Likert" &&
  x$Payload$SubSelector == "MultipleAnswer"){
    respondents_count <- sapply(x$Responses, function(y) strtoi(length(which(y != -99))))
    return(respondents_count)
  } else if (x$Payload$Selector == "Bipolar"){
    respondents_count <- sapply(x$Responses, function(y) strtoi(length(which(y != -99))))
    return(respondents_count)
  } else if (x$Payload$Selector == "Likert" &&
  x$Payload$SubSelector == "DL"){
    respondents_count <- sapply(x$Responses, function(y) strtoi(length(which(y != -99))))
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
  array <- cbind(Choices=sapply(x$Payload$Choices, function(y) y$Display), array)
  array <- as.data.frame(array)
  return(array)
}

matrix_bipolar_get_results <- function(x) {
  array <- matrix_factor_choices_by_answers(x)
  for (i in 1:nrow(array)) {
    for (j in 1:ncol(array)) {
      array[i,j] <- percent(strtoi(array[i,j]) /
      matrix_get_respondents_count(x)[i])
    }
  }
  choices <- sapply(x$Payload$Choices, function(y) y$Display)
  left_choices <- sapply(choices, function(y) sapply(strsplit(y, ":"), "[", 1))
  right_choices <- sapply(choices, function(y) sapply(strsplit(y, ":"), "[", 2))

  array <- cbind(left_choices, array)
  array <- cbind(array, right_choices)

  # set the column headers for the first and last column to empty
  # colnames(array)[ncol(array)] <- ""
  # colnames(array)[1] <- ""
  array <- as.data.frame(array)
  return(array)
}

matrix_multiple_answer_get_results <- function(x) {
  headernames <- sapply(x$Payload$Answers, function(y) y$Display)
  rownames <- sapply(x$Payload$Choices, function(y) y$Display)
  ma_matrix_sums <- sapply(x$Responses, function (y) sum(y == 1))
  chunk2 <- function(y,n) split(y, cut(seq_along(y), n, labels = FALSE))
  df <- t(as.data.frame((chunk2(ma_matrix_sums, length(headernames)))))
  rownames(df) <- rownames
  colnames(df) <- headernames
  respondents_count <- matrix_get_respondents_count(x)[seq(1,
    length(x$Responses), length(headernames))]
    for (i in 1:nrow(df)) {
      for (j in 1:ncol(df)) {
        df[i,j] <- percent(strtoi(df[i,j]) /
        matrix_get_respondents_count(questions[[6]])[i])
      }
    }
    df <- cbind(df, N=respondents_count)
    df <- cbind(Choices=sapply(x$Payload$Choices, function(y) y$Display), df)
    return(df)
  }

# Loops through all the matrix single answer questions and generates the
# table and kable code.
for (i in matrix_single_answer_questions) {
  questions[[i]]$Table = matrix_single_answer_get_results(questions[[i]])
}
for (i in matrix_bipolar_questions) {
  questions[[i]]$Table = matrix_bipolar_get_results(questions[[i]])
}
for (i in matrix_multiple_answer_questions) {
  questions[[i]]$Table = matrix_multiple_answer_get_results(questions[[i]])
}
