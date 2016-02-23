### Notes for Feb 22

Working on generating a response table for a multiple choice normal matrix question.
Looking at `questions[[2]]$Payload$QuestionType` we see that the question 2 is a matrix question.


[Length of vector not counting NA responses](https://stat.ethz.ch/pipermail/r-help/2010-September/253897.html)

To get the length of a vector not including NA responses, use `length(x[!is.na(x)])`.

    not_na_length <- function(x) length(x[!is.na(x)])
    not_na_length(questions[[2]]$Responses[[1]])
    N <- sapply(questions[[2]]$Responses, not_na_length)

    > N
    Q2_1 Q2_2 Q2_3 Q2_4
    4    4    4    5

`N` is the number of responses to each question in the matrix.

`questions[[2]]$Payload$Answers` are the columns in the matrix.

`questions[[2]]$Payload$Choices` are the rows in the matrix.

    > matrix_answers <- function(x) sapply(x$Responses, function(y) table(factor(y, levels=x$Payload$AnswerOrder)))

    > matrix_answers(questions[[2]])
      Q2_1 Q2_2 Q2_3 Q2_4
    1    1    2    1    1
    2    3    1    1    3
    3    0    1    2    1

[Check that vector is not all NA](https://stackoverflow.com/questions/9417391/how-to-check-if-entire-vector-has-no-values-other-than-na-or-nan-in-r)
We'll need this to check that a response is valid.
    
    > all(is.na(as.data.frame(questions[[1]]$Responses)[5,]))
    [1] TRUE
