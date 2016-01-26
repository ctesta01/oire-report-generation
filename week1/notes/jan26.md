###Data Modeling
Hopefully this project follows a [model-view-controller](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller) architecture.
Starting with the model, I'm messing around with an example QSF file with a single response to look at the data in the QSF file.
The QSF file is just a JSON format file, easily imported to R using the following library + code.

    install.packages("rjson")
    library("rjson")
    json_data <- fromJSON(file=json_file)

- [Importing data from a JSON file into R](https://stackoverflow.com/questions/2617600/importing-data-from-a-json-file-into-r)
- [Package 'rjson'](https://cran.r-project.org/web/packages/rjson/rjson.pdf)


Let's say you've imported the survey's qsf file into R as the variable `json_data`

`json_data` is a list of lists, `SurveyEntry` and `SurveyElements`. SurveyEntry has the following fields in it:

    > names(json_data$SurveyEntry)
     [1] "SurveyID"                "SurveyName"
     [3] "SurveyDescription"       "SurveyOwnerID"
     [5] "SurveyBrandID"           "DivisionID"
     [7] "SurveyLanguage"          "SurveyActiveResponseSet"
     [9] "SurveyStatus"            "SurveyStartDate"
    [11] "SurveyExpirationDate"    "SurveyCreationDate"
    [13] "CreatorID"               "LastModified"
    [15] "LastAccessed"            "LastActivated"
    [17] "Deleted"

Every SurveyElement has the following structure:

    > names(json_data$SurveyElement[[7]])
    [1] "SurveyID"           "Element"            "PrimaryAttribute"
    [4] "SecondaryAttribute" "TertiaryAttribute"  "Payload"

The PrimaryAttribute is pretty useful at telling us what each element actually is:

    > for(i in 1:7) {
    + print(json_data$SurveyElements[[i]]$PrimaryAttribute)
    + }
    [1] "Survey Blocks"
    [1] "Survey Flow"
    [1] "Survey Options"
    [1] "Scoring"
    [1] "Survey Statistics"
    [1] "Survey Question Count"
    [1] "QID1"

Perhaps most interesting is the last listed here, an actual question:

    > names(json_data$SurveyElements[[7]]$Payload)
     [1] "QuestionText"        "DataExportTag"       "QuestionType"
     [4] "Selector"            "SubSelector"         "Configuration"
     [7] "QuestionDescription" "Choices"             "ChoiceOrder"
    [10] "Validation"          "Language"            "QuestionID"
