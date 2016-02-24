### Feb 24 Notes

    is_multiple_choice_check_all <- function(x) {
      return(x$Payload$QuestionType == "MC" && x$Payload$Selector == "MAVR")
    }

    is_multiple_choice_single_answer <- function(x) {
      return(x$Payload$QuestionType == "MC" &&
      x$Payload$Selector == "SAVR")
    }

Most important question types:
Multiple Choice: Dropdown list
Multiple Choice: Single Answer
Multiple Choice: Multiple Answer
Matrix Table: Bipolar
Matrix Table: Likert, Single Answer
Matrix Table: Likert, Multiple Answer
Matrix Table: Likert, Drop Down list
Rank Order: Drag and Drop
Rank Order: Radio Buttons
