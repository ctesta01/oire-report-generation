is_multiple_choice_check_all <- function(x) {
  return(x$Payload$QuestionType == "MC" &&
  (x$Payload$Selector == "MAVR" ||
  x$Payload$Selector == "MAHR" ||
  x$Payload$Selector == "MACOL")
  )
}

is_multiple_choice_single_answer <- function(x) {
  return(x$Payload$QuestionType == "MC" &&
         (x$Payload$Selector == "SAVR" ||
         x$Payload$Selector == "SAHR" ||
         x$Payload$Selector == "SACOL")
         )
}

mc_get_choices <- function(x) {
  return(sapply(x$Payload$Choices, function(x) x$Display))
}

mc_get_respondents_count <- function(x) {
  return(length(x$Responses != -99))
}

mc_get_choice_responses <- function(x) {
  return(as.data.frame(table(factor(x$Responses[[1]], levels=x$Payload$ChoiceOrder)))[,2])
}

mc_get_results <- function(x) {
  N <- mc_get_choice_responses(x)
  Percent <- percent(mc_get_choice_responses(x) / mc_get_respondents_count(x))
  Answers <- mc_get_choices(x)
  return(data.frame(N, Percent, Answers))
}
