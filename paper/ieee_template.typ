// #let title = "Formally verified drone landing"
#let ieee(title, abstract, keywords, bibliography_file, doc) = {
set text(
    font: "STIX Two Text ",
    size: 10pt,
)

set page(
    paper: "us-letter",
    header: smallcaps("IEEE ICR 2023")
)

set heading(numbering: "I.A.1.")
show heading: it => [
    #set align(center)
    #set text(size: 10pt, weight: "regular")
    #it
]

align(center, text(24pt)[
    #title
])
set par(
    first-line-indent: 2em,
    justify: true,
)
align(center,[
    Jonathan Hellwig \
    Department of Informatics \
    Karlsruhe Institute of Technology \
    Karlsruhe, Germany \
    #link("mailto:jonathan.hellwig@kit.edu")
])

let abstract_and_keywords = [
    #h(1em)*_Abstract_ --- #abstract*\
    #h(1em)*_Keywords_ --- #keywords*
]
let bibliography_body = bibliography(bibliography_file, title: text(10pt)[References], style: "ieee")
columns(2, abstract_and_keywords + doc + bibliography_body)

}
