### Feb 25 Notes

Finished up the multiple choice question functions just now.

Starting on the matrix question functions.

    > questions[[8]]$Responses
      QID2_1 QID2_2 QID2_3
    1      1      2      2
    2      2      2    -99
    3      2      2      2
    4      2      2      2
    5    -99    -99    -99
    6      3      3      3
    > answers_by_responses <- as.data.frame(sapply(questions[[8]]$Responses, function(x) as.data.frame(table(factor(x, levels=questions[[8]]$Payload$AnswerOrder)))[,2]))
    > answers <- sapply(questions[[8]]$Payload$Answers, function(x) x[[1]])
    > colnames(answers_by_responses) <- answers
    > answers_by_responses
           Very Dissatisfied Dissatisfied  Neutral Satisfied Very Satisfied
    QID2_1                 1             3       1         0              0
    QID2_2                 0             4       1         0              0
    QID2_3                 0             3       1         0              0
    > kable(answers_by_responses)
    |                        | Very Dissatisfied| Dissatisfied | Neutral| Satisfied| Very Satisfied|
    |:-----------------------|-----------------:|-------------:|-------:|---------:|--------------:|
    |Click to write Choice 1 |                 1|             3|       1|         0|              0|
    |Click to write Choice 2 |                 0|             4|       1|         0|              0|
    |Click to write Choice 3 |                 0|             3|       1|         0|              0|

The number of valid respondents will be individual to each choice for
single answer likert matrix questions.
