#let tum-ivory = color.rgb("#DAD7CB")

#let label-cell(input) = {
  table.cell(stroke: none, text(size: 12pt, str(input)))
}

#let empty-cell = table.cell(stroke: none, "")

#let array-table(contents) = {
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
    numbers.map(str) + (table.cell(fill: tum-ivory, ""),) * (capacity - numbers.len()),
  )
}

#let array-range-table(values, begin, end) = {
  array-table(values.enumerate().map(t => {
    let (i, v) = t
    table.cell(stroke: (
      left: if (i == begin or i == end) { 4pt } else { 1pt },
      right: if (i == end - 1) { 4pt } else { 1pt },
      rest: 1pt,
    ), fill: if (i >= begin and i < end) { tum-ivory } else { none }, v)
  }))
}
