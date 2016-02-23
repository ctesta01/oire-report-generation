### Feb 23 Notes

Question 1 is a multiple choice check all that apply question.

We can reshape that data into a list of the rows instead of how it was originally shaped as a list of columns. A list of rows is equivalent to a list of responses, with question fields, and a list of columns is equivalent to a list of question fields with individual responses.

    > questions[[1]]$Responses
    Q3_1 Q3_2 Q3_3 Q3_4
    1   NA    1    1   NA
    2    1    1   NA    1
    3    1   NA   NA    1
    4   NA   NA   NA    1
    5   NA   NA   NA   NA
    qdf <- as.data.frame(questions[[1]]$Responses)
    qdf.list <- split(q1df, seq(nrow(q1df)))
    > sapply(qdf.list, function(x) all(is.na(x)))
        1     2     3     4     5
    FALSE FALSE FALSE FALSE  TRUE
    > sum(sapply(q1df.list, function(x) all(is.na(x))) == FALSE)
    [1] 4

The end result here is the number of responses to the question with not all NA responses.

    > Choices <- sapply(questions[[3]]$Payload$Choices, function(x) x$Display)
    > N <- length(questions[[3]]$Responses != -99)
    > Choice_Responses <- as.data.frame(table(factor(questions[[3]]$Responses[[1]], levels=questions[[3]]$Payload$ChoiceOrder)))[,2]
    > Percents <- Choice_Responses / N
    > q3 <- data.frame(Choice_Responses, Percents, Choices)
