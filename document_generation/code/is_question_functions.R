# is_multiple_choice_check_all checks whether
# or not the questions QuestionType is "MC" and
# whether it has one of the vertical, horizontal, or column
# multiple answer question formats.
is_multiple_choice <- function(x) {
  return(
    (x$Payload$QuestionType == "MC" &&
  (x$Payload$Selector == "MAVR" ||
  x$Payload$Selector == "MAHR" ||
  x$Payload$Selector == "MSB" ||
  x$Payload$Selector == "MACOL")
  ) ||
  (x$Payload$QuestionType == "Matrix" &&
    x$Payload$SubSelector == "MultipleAnswer"
    ))
}

# is_multiple_choice_single_answer checks whether
# or not the questions QuestionType is "MC" and
# whether it has one of the vertical, horizontal, or column
# single answer question formats.
is_single_answer <- function(x) {
  return(
    (x$Payload$QuestionType == "MC" &&
         (x$Payload$Selector == "SAVR" ||
         x$Payload$Selector == "SAHR" ||
         x$Payload$Selector == "SACOL" ||
         x$Payload$Selector == "DL" ||
         x$Payload$Selector == "SB")) ||
         (x$Payload$QuestionType == "Matrix" && (
           x$Payload$SubSelector == "DL" ||
           x$Payload$Selector == "Bipolar" ||
           x$Payload$SubSelector == "SingleAnswer"
           ))

         )
}

is_rank_order <- function(x) {
  return(x$Payload$QuestionType == "RO")
}

is_text_entry <- function(x) {
  return(x$Payload$QuestionType == "TE")
}

is_matrix_question <- function(x) {
  return(x$Payload$QuestionType == "Matrix")
}
