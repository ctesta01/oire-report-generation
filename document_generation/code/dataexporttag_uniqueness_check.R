dataexporttags <- sapply(questions, function(x) x$Payload$DataExportTag)
if (any(duplicated(dataexporttags))) {
  stop(paste("There are questions with duplicated data export tags!
  Please re-number the questions in Qualtrics,
  redownload the QSF and CSV files,
  and run the script with the new files.
  The following data export tags are duplicated:",
  toString(dataexporttags[which(duplicated(dataexporttags))]), sep=" "))
  quit()
}
