output$SurveyAttributes <- survey$SurveyEntry
output$Blocks <- Blocks[[1]]$Payload
exportJSON <- toJSON(output)
save(exportJSON, file="output/export.JSON")
