dataexporttags <- sapply(questions, function(x) x$Payload$DataExportTag)
if (any(duplicated(dataexporttags))) {
    stop("Duplicate Data Export Tags! Renumber the questions, please!")
    quit()
}
