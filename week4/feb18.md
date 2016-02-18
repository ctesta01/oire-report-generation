### Notes for Feb 18th
Going through the OIRE Preview Template that we're aiming to replicate, there are a couple different points that will have to be considered later:
- Questions with specific formatting, like questions where including a "Mean" column is appropriate (or standard deviation, etc)
- Different kinds of questions:
  - Check all that apply
  - Multiple choice
  - Single sided / Normal matrix questions
  - Double-sided matrix questions
- Placeholders for free response questions with their coded comments
- Response Completeness

Why are Q1 and Q2 formatted not in a similar table format to the other multiple choice questions?

Questions should appear in the document in the order and blocks that they appear in in the survey. Later on there should be options for including blocks as a header or not.

Filtering by student groups, for example students from Fletcher, should be an option. There should be the option to choose to display Question 1 as answered by Fletcher students, Tisch college students, and AS&E undergrads independently.


For a check all that apply question, this tallys the

    > questions[[1]]$Responses
      Q3_1 Q3_2 Q3_3 Q3_4
    1   NA    1    1   NA
    2    1    1   NA    1
    3    1   NA   NA    1
    4   NA   NA   NA    1
    5   NA   NA   NA   NA

    > sapply(1:length(questions[[1]]$Responses), function(x) table(questions[[1]]$Responses[[x]])[[1]])
    [1] 2 2 1 3


For a single option multiple choice question, this tallys the responses

    > questions[[3]]$Payload$ChoiceOrder
    [1] 1 2 3 4

    > questions[[3]]$Responses
      Q1
    1  1
    2  3
    3  3
    4  3
    5  4

    > table(factor(questions[[3]]$Responses[[1]],
    levels=questions[[3]]$Payload$ChoiceOrder))
    1 2 3 4
    1 0 3 1
