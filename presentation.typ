#import "./polylux/polylux.typ": *
#import "@preview/diagraph:0.2.0": *
#import "@preview/codly:0.2.1": *
#import "@preview/pinit:0.1.4": *
#import "./typst-svg-emoji/lib.typ": setup-emoji

#show: setup-emoji

#import "./tum-theme.typ": *

#set text(font: "Arial")

#show: tum-theme.with(short-title: [Example], short-date: "18.11.24", font-size: 18pt)

#title-slide(
  title: "Example presentation",
  subtitle: "Subtitle",
  authors: "Tobias Ribizel" + linebreak() + link("mailto:tobias.ribizel@tum.de"),
  institute-name: "Campus Heilbronn" + linebreak() + "TUM School of Computation, Information and Technology",
  date: "November 18th 2024",
)

#let icon(codepoint) = {
  box(height: 0.8em, baseline: 0.05em, image(codepoint))
}
#show: codly-init.with()
#codly(
  languages: (
    cpp: (name: "", icon: icon("cpp-logo.svg"), color: white),
    cmake: (name: "", icon: icon("cmake-logo.svg"), color: white),
    bash: (
      name: "",
      icon: box(height: 0.8em, baseline: 0.05em, text(size: 10pt, emoji.dollar + "_")),
      color: white,
    ),
  ),
  enable-numbers: false,
)

#let label-cell(input) = {
  table.cell(stroke: none, text(size: 12pt, str(input)))
}

#let empty-cell = table.cell(stroke: none, "")

#let array-table(contents, highlight: i => white) = {
  table(
    rows: (1em, 2em),
    columns: (2em,) * contents.len(),
    align: center + horizon,
    ..(range(contents.len()).map(i => label-cell(str(i))) + contents),
  )
}

#let string-to-chars(string) = {
  string.codepoints().map(c => raw("'" + str(c) + "'"))
}

#let string-table(string) = {
  array-table(string-to-chars(string))
}

#let cstring-table(string) = {
  array-table(string-to-chars(string) + (raw("'\0'"),))
}

#let number-table(numbers) = {
  array-table(numbers.map(str))
}

#let vector-table(numbers, capacity) = {
  array-table(
    numbers.map(str) + (table.cell(fill: silver, ""),) * (capacity - numbers.len()),
  )
}

#slide[
#tum-chapter.update(raw("std::vector"))
= `std::vector` example
#v(-0.3em)
#raw(lang: "cpp", "std::vector<int> numbers(4, 2);")
#v(-1.15em)
#vector-table((2, 2, 2, 2), 4)
#v(-0.85em)
#raw(lang: "cpp", "numbers.push_back(1);")
#v(-1.15em)
#vector-table((2, 2, 2, 2, 1), 8)
#v(-0.85em)
#raw(lang: "cpp", "numbers.pop_back();")
#v(-1.15em)
#vector-table((2, 2, 2, 2), 8)
#v(-0.85em)
#raw(lang: "cpp", "numbers.push_back(4); // 5x")
#v(-1.15em)
#vector-table((2, 2, 2, 2, 4, 4, 4, 4, 4), 16)
#v(-0.85em)
#raw(lang: "cpp", "numbers.clear();")
#v(-1.15em)
#vector-table((), 16)
]

#slide[
= Deep dive: Memory layout of a `struct`
- The members of a `struct` will be stored in order next to each other in memory
- The compiler may introduce _padding_ between members, e.g. to preserve alignment

```cpp
struct student {
    std::string name;
    int year;
    double average_grade;
};
```
]

#let struct-layout-table = table(
  rows: (1em, 1.5em),
  columns: (1em, 1em, 1em, 1em, 1em, 1em, 1em, 1em, 1em),
  align: center + horizon,
  table.cell(stroke: none, ""),
  label-cell(0),
  label-cell(""),
  label-cell(2),
  label-cell(""),
  label-cell(4),
  label-cell(""),
  label-cell(6),
  label-cell(""),
  label-cell(0),
  table.cell(
    colspan: 8,
    rowspan: 4,
    align: horizon + right,
    align(center, raw("name") + pin("begin")),
  ),
  label-cell(8),
  label-cell(16),
  label-cell(24),
  label-cell(32),
  table.cell(colspan: 4, raw("year")),
  table.cell(fill: silver, colspan: 4, text(size: 11pt, "padding")),
  label-cell(36),
  table.cell(colspan: 8, raw("average_grade")),
)

#slide[
= Deep dive: Memory layout of a `struct`
#layout(l => rect(width: 85% * l.width, stroke: none, ```cpp
struct student {
    std::string name;
    int year;
    double average_grade;
};
```))
#v(-1em)
#grid(
  columns: (10em, 40em),
  struct-layout-table,
  v(1.2em) + list(
    raw("sizeof(std::string) == 32") + " (bytes) usually" + super("1, 2"),
    raw("alignof(std::string) == 8") + " (bytes) usually" + super("1, 2") + v(3.3em),
    raw("sizeof(int) == alignof(int) == 4") + super("1"),
    raw("sizeof(double) == alignof(double) == 8") + super("1"),
  ),
)

#super[1] compiling for a 64 bit CPU #h(4em)
#super[2] with libstdc++ (default implementation on Linux)
]
