#import "./polylux/logic.typ"
#import "./polylux/utils/utils.typ"

#let tum-colors = state("tum-colors", (:))
#let tum-short-title = state("tum-short-title", none)
#let tum-short-author = state("tum-short-author", none)
#let tum-short-date = state("tum-short-date", none)
#let tum-progress-bar = state("tum-progress-bar", true)
#let tum-chapter = state("tum-chapter", none)
#let tum-logo-size = 1.5cm
#let tum-ivory = color.rgb("#DAD7CB")
#let tum-orange = color.rgb("#E37222")
#let tum-green = color.rgb("#A2AD00")
#let tum-blue = color.rgb("#005293")
#let tum-darkblue = color.rgb("#003359")

#let tum-theme(
  aspect-ratio: "16-9",
  short-title: none,
  short-author: none,
  short-date: none,
  font-size: 20pt,
  color-a: rgb("#0065bd"),
  color-b: rgb("#e37222"),
  color-c: rgb("#a2ad00"),
  progress-bar: true,
  body,
) = {
  set page(
    paper: "presentation-" + aspect-ratio,
    margin: 0em,
    header: none,
    footer: none,
  )
  set text(size: font-size, font: "Arial")
  show footnote.entry: set text(size: .6em)

  tum-progress-bar.update(progress-bar)
  tum-colors.update((a: color-a, b: color-b, c: color-c))
  tum-short-title.update(short-title)
  tum-short-author.update(short-author)
  tum-short-date.update(short-date)

  body
}

#let title-slide(
  title: [],
  subtitle: none,
  authors: (),
  institute-name: "",
  institution-name: "University",
  date: none,
) = {
  let authors = if type(authors) == "array" { authors } else { (authors,) }

  let content = locate(loc => {
    let colors = tum-colors.at(loc)
    let logo-size = tum-logo-size

    layout(size => place(top, grid(
      columns: (50% * size.width, 50% * size.width),
      align(left, rect(height: logo-size, inset: logo-size, text(
        stroke: none,
        fill: colors.a,
        weight: "extralight",
        size: logo-size / 4,
        institute-name + linebreak() + "Technical University of Munich",
      ), stroke: none)),
      align(right, rect(
        image("tum-logo.svg", height: logo-size),
        stroke: none,
        inset: logo-size,
      )),
    )))

    align(center + horizon, {
      block(inset: 0em, breakable: false, {
        text(size: 2em, fill: colors.a, strong(title))
        if subtitle != none {
          parbreak()
          text(size: 1.2em, fill: colors.a, subtitle)
        }
      })
      set text(size: .8em)
      grid(
        columns: (1fr,) * calc.min(authors.len(), 3),
        column-gutter: 1em,
        row-gutter: 1em,
        ..authors.map(author => text(fill: black, author)),
      )
      v(1em)
      if date != none {
        parbreak()
        text(size: .8em, date)
      }
    })
  })

  logic.polylux-slide(content)
}

#let slide(title: none, header: none, footer: none, new-section: none, body) = {
  let logo-size = tum-logo-size
  let margin-top = 2em
  let margin-bottom = 2em
  let body = place(top + right, rect(
    image("tum-logo.svg", height: logo-size),
    stroke: none,
    inset: (top: logo-size - margin-top, right: logo-size),
  )) + pad(x: 2em, y: .5em, body)

  let progress-barline = locate(
    loc => {
      if tum-progress-bar.at(loc) {
        let cell = block.with(width: 100%, height: 100%, above: 0pt, below: 0pt, breakable: false)
        let colors = tum-colors.at(loc)

        utils.polylux-progress(ratio => {
          grid(
            rows: 2pt,
            columns: (ratio * 100%, 1fr),
            cell(fill: colors.a),
            cell(fill: white),
          )
        })
      } else { [] }
    },
  )

  let header-text = {
    if header != none {
      header
    } else if title != none {
      if new-section != none {
        utils.register-section(new-section)
      }
      locate(
        loc => {
          let colors = tum-colors.at(loc)
          block(
            fill: colors.c,
            inset: (x: .5em),
            grid(
              columns: (60%, 40%),
              align(top + left, heading(level: 2, text(fill: colors.a, title))),
              align(top + right, text(fill: colors.a.lighten(65%), utils.current-section)),
            ),
          )
        },
      )
    } else { [] }
  }

  let header = {
    set align(top)
    grid(rows: (auto, auto), row-gutter: 3mm, progress-barline, header-text)
  }

  let footer = {
    set text(size: 16pt)
    let inset = 1em
    locate(
      loc =>
      layout(
        size => rect(
          inset: inset,
          stroke: none,
          grid(
            columns: (80% * (size.width - 2 * inset), 20% * (size.width - 2 * inset)),
            align: (left, right),
            tum-short-date.display() + " | " + tum-short-title.display() + (
              if tum-chapter.at(loc) != none { " | " + tum-chapter.at(loc) } else { "" }
            ),
            logic.logical-slide.display() + [~/~] + utils.last-slide-number,
          ),
        ),
      ),
    )
  }

  set page(
    margin: (top: margin-top, bottom: margin-bottom, x: 0em),
    header: header,
    footer: footer,
    footer-descent: 0em,
    header-ascent: .6em,
  )

  logic.polylux-slide(body)
}

#let focus-slide(background-color: none, background-img: none, body) = {
  let background-color = if background-img == none and background-color == none {
    rgb("#0C6291")
  } else {
    background-color
  }

  let logo-size = tum-logo-size
  let margin = 1em
  set page(fill: background-color, margin: margin) if background-color != none
  set page(background: {
    set image(fit: "stretch", width: 100%, height: 100%)
    background-img
  }, margin: margin) if background-img != none

  set text(fill: white, size: 2em)

  logic.polylux-slide(place(top + right, rect(
    image("tum-logo-white.svg", height: logo-size),
    stroke: none,
    inset: logo-size - margin,
  )) + align(horizon, body))
}

#let matrix-slide(columns: none, rows: none, ..bodies) = {
  let bodies = bodies.pos()

  let columns = if type(columns) == "integer" {
    (1fr,) * columns
  } else if columns == none {
    (1fr,) * bodies.len()
  } else {
    columns
  }
  let num-cols = columns.len()

  let rows = if type(rows) == "integer" {
    (1fr,) * rows
  } else if rows == none {
    let quotient = calc.quo(bodies.len(), num-cols)
    let correction = if calc.rem(bodies.len(), num-cols) == 0 { 0 } else { 1 }
    (1fr,) * (quotient + correction)
  } else {
    rows
  }
  let num-rows = rows.len()

  if num-rows * num-cols < bodies.len() {
    panic(
      "number of rows (" + str(num-rows) + ") * number of columns (" + str(num-cols) + ") must at least be number of content arguments (" + str(bodies.len()) + ")",
    )
  }

  let cart-idx(i) = (calc.quo(i, num-cols), calc.rem(i, num-cols))
  let color-body(idx-body) = {
    let (idx, body) = idx-body
    let (row, col) = cart-idx(idx)
    let color = if calc.even(row + col) { white } else { silver }
    set align(center + horizon)
    rect(inset: .5em, width: 100%, height: 100%, fill: color, body)
  }

  let content = grid(
    columns: columns,
    rows: rows,
    gutter: 0pt,
    ..bodies.enumerate().map(color-body),
  )

  logic.polylux-slide(content)
}
