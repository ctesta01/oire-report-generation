### The OIRE Report Generation Project

This is a project using R, LaTeX, Pandoc,
Knitr, and Qualtrics Survey Data to automatically generate and create survey
reports.

##### Description of Processes in `script.R`
- `header.R`: Loads requisite libraries, survey data, and
response data. Survey is under variable name `survey`, and responses are under variable name `responses`.
- `questions.R`: Creates a list of questions called `questions`
from the `survey` object, and strips HTML out of
the question descriptions.
- `delete_trash_questions.R`: Creates a list of survey blocks, called `Blocks`, finds the trash block, and deletes any questions in the trash block from the `questions` list.
- `link_responses_to_questions.R`: inserts columns from the `response` data with headers that match the question's `DataExportTag` into the matching question under the `Responses`
sublist (ie `questions[[1]]$Responses`).
- `mc_question_functions.R`: Generates the table for response
data for multiple choice questions and inserts it into the `Table` sublist. The `kable` package is used to generate code to print the table in LaTeX and that code is saved under the `Kable` list element in the question. (ie `questions[[1]]$Table` and `questions[[1]]$Kable` if `questions[[1]]` is a multiple choice question).
- `questions_into_blocks.R`: Moves the individual questions
from the `questions` list into the `Blocks` list under
their corresponding block and in the order they appear in the blocks.
- knitting: The document iterates through the Blocks, printing each question with its corresponding table under the block subsection. `knitr` renders this document to LaTeX code.
