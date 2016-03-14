# is_multiple_choice_check_all checks whether
# or not the questions QuestionType is "MC" and
# whether it has one of the vertical, horizontal, or column
# multiple answer question formats.
is_multiple_choice_check_all <- function(x) {
  return(x$Payload$QuestionType == "MC" &&
  (x$Payload$Selector == "MAVR" ||
  x$Payload$Selector == "MAHR" ||
  x$Payload$Selector == "MACOL")
  )
}

# is_multiple_choice_single_answer checks whether
# or not the questions QuestionType is "MC" and
# whether it has one of the vertical, horizontal, or column
# single answer question formats.
is_multiple_choice_single_answer <- function(x) {
  return(x$Payload$QuestionType == "MC" &&
         (x$Payload$Selector == "SAVR" ||
         x$Payload$Selector == "SAHR" ||
         x$Payload$Selector == "SACOL" ||
         x$Payload$Selector == "DL")
         )
}

# mc_get_choices gets the choice options from the question
get_question_choices <- function(x) {
  return(sapply(x$Payload$Choices, function(x) x$Display))
}

# mc_single_value_get_respondents_count checks how many responses are not
# -99.
mc_single_answer_get_respondents_count <- function(x) {
  return(length(which(x$Responses != -99)))
}

# mc_check_all_get_respondents_count does not check whether or not
# responses are valid or not, unlike mc_single_value_get_respondents_count
# does.
mc_check_all_get_respondents_count <- function(x) {
  return(length(which(x$Responses != -99)))
}

# mc_single_answer_get_choice_responses takes the list of variables from
# the ChoiceOrder list and returns how many times each choice was chosen
mc_single_answer_get_choice_responses <- function(x) {
  return(as.data.frame(table(factor(x$Responses[[1]],
    levels=x$Payload$ChoiceOrder)))[,2])
}

# mc_check_all_get_choice_responses sums all the 1 values in each column
# where a column corresponds to a specific choice (because it is a check-all
# question).
mc_check_all_get_choice_responses <- function(x) {
  return(sapply(x$Responses, function (y) sum(y == 1)))
}

# mc_single_answer_get_results creates the response table for a single answer
# multiple choice question. It returns a data frame where each choice is a row.
# The first column is the number of respondents who chose that choice,
# the second column is the percentage of respondents who chose that choice
# out of the total valid respondents, and the third row is the choice text.
mc_single_answer_get_results <- function(x) {
  N <- mc_single_answer_get_choice_responses(x)
  Percent <- percent(mc_single_answer_get_choice_responses(x) /
    mc_single_answer_get_respondents_count(x))
    df <- data.frame(N, Percent, get_question_choices(x))
    colnames(df)[ncol(df)] <- ""
  return(df)
}

# mc_check_all_get_results creates the response table for a check all that
# apply multiple choice question. It returns a data frame where each choice is
# a row. The first column is the number of respondents who chose that choice,
# the second column is the percentage of respondents who chose that choice out
# of the total valid respondents, and the third row is the choice text.
mc_check_all_get_results <- function(x) {
  N <- mc_check_all_get_choice_responses(x)
  Percent <- percent(mc_check_all_get_choice_responses(x) /
    mc_check_all_get_respondents_count(x))
    df <- data.frame(N, Percent, get_question_choices(x))
    colnames(df)[ncol(df)] <- ""
  return(df)
}

mc_ca_questions = which(sapply(questions, is_multiple_choice_check_all))
for (i in mc_ca_questions) {
  questions[[i]]$Table = mc_check_all_get_results(questions[[i]])
  questions[[i]]$Kable = kable(questions[[i]]$Table, format = 'latex',
  row.names = FALSE)
}

mc_sa_questions = which(sapply(questions, is_multiple_choice_single_answer))
for (i in mc_sa_questions) {
  questions[[i]]$Table = mc_single_answer_get_results(questions[[i]])
  questions[[i]]$Kable = kable(questions[[i]]$Table, format = 'latex',
  row.names = FALSE)
}
