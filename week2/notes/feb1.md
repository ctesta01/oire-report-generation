### Notes of week2 in oire-report-generation

It looks like we'll be able to use pandoc to convert between some of the file
formats we're working with, and that should make the process a lot easier to
work with.

We can try to use pandoc to convert any question text that contains html tags
into plain-text to try to reduce the amount of corrections that have to be
done post-rendering.

An issue is that there might be some select latex packages that don't work
with pandoc, the tool we'd use to convert back and forth between the file
formats (latex and docs, etc.). I already saw this happen with the table of
contents that is visible in the rendered pdf of the latex document I was
testing with. The table of contents didn't render in the docx, and only appeared
in the pdf.

The examples I'm talking about are in the week2/examples directory.

#### Examples of Pandoc Usage for later reference

    pandoc -s html_to_text.html -o html_to_text.text
    pandoc -s dynamic.tex -o dynamic.docx

- [Pandoc Usage in R](http://www.inside-r.org/packages/cran/knitr/docs/pandoc)
This looks like it could be handy.

- [How to convert a scientific manuscript from LaTeX to Word using Pandoc?](https://tex.stackexchange.com/questions/111886/how-to-convert-a-scientific-manuscript-from-latex-to-word-using-pandoc)
This suggests that there might be some problems with using pandoc for converting between latex to docx file formats.


#### Knitr Documentation
- [The Knitr Book](https://github.com/yihui/knitr/releases/download/doc/DDR-Yihui-Xie-Chap1-3.pdf)
- [The Manual](https://github.com/yihui/knitr/releases/download/doc/knitr-manual.pdf)
- [The Graphics Manual](https://github.com/yihui/knitr/releases/download/doc/knitr-graphics.pdf)
- [FAQ](http://bit.ly/knitr-faq)

I didn't immediately see these on the knitr website when I was first reading it, so I'm saving them here so I don't lose them again.

#### Running External Code
Write R code in external R scripts, and use `read_chunk()` to read them into the current document.

    {r cache=FALSE}
    knitr::read_chunk('113-foo.R')
    {r test-a}
    {r test-b}
