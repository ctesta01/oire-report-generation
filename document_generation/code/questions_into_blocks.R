for (i in 1:length(Blocks[[1]]$Payload)) {
  for (j in 1:length(Blocks[[1]]$Payload[[i]]$BlockElements)) {
    Blocks[[1]]$Payload[[i]]$BlockElements[[j]] =
    questions[which(sapply(questions, function(x)
    x$Payload$QuestionID ==
    Blocks[[1]]$Payload[[i]]$BlockElements[[j]]$QuestionID))]
  }
}
