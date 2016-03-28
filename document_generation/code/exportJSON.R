output <- list()
output$SurveyAttributes <- survey$SurveyEntry
output$Blocks <- Blocks[[1]]$Payload
exportJSON <- toJSON(output)
write(exportJSON, file="output/export.JSON")
