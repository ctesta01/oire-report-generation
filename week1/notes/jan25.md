###Project Goals
Automatic generation of survey previews. Original data, templating, and final products (reports) should be the three major components of the project.

###Initial Research
There are some different options. It sounds like Knitr is the most popular and most modern of the options looked at.

####Knitr + R
- [Knitr Website](http://yihui.name/knitr/)
- [Knitr GitHub Page](https://github.com/yihui/knitr)
- [Getting Started with R Markdown, knitr, and Rstudio](http://jeromyanglim.blogspot.nl/2012/05/getting-started-with-r-markdown-knitr.html)

####Sweave + R
- [Sweave](http://astrostatistics.psu.edu/su07/R/html/utils/html/Sweave.html)
- [Getting started with Sweave](http://jeromyanglim.blogspot.com/2010/02/getting-started-with-sweave-r-latex.html)

####StackExchange
- [Automatic document generation based on a database](https://tex.stackexchange.com/questions/270714/automatic-document-generation-based-on-a-database/270928#270928)
- [Generating reports with LaTeX programmatically](https://tex.stackexchange.com/questions/48550/generating-reports-with-latex-programmatically)
- [How can latex help me format and present lots of data in a report?](https://tex.stackexchange.com/questions/238618/how-can-latex-help-me-format-and-present-lots-of-data-in-a-report)
- [Is anybody using TeX for business reporting?](https://tex.stackexchange.com/questions/3506/is-anybody-using-tex-for-business-reporting)
- [Knitr Tag on Stackexchange](https://tex.stackexchange.com/questions/tagged/knitr?sort=votes)

####LaTeX
- [TeX Package : datatool](http://ctan.org/pkg/datatool)

Use XeLaTeX to use system fonts!

Example of compiling sweave/knitr via command line. The following is the knitr document. Save as my_knitr_file.Rnw

    \documentclass{article}
    \begin{document}
    Some text
    <<RTest>>=
    2+2
    @
    \end{document}

Then run from the command line:

    Rscript -e "library(knitr); knit('my_sweave_file.Rnw')"
    pdflatex my_knitr_file.tex
