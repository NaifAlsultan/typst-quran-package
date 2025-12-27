#import "../src/lib.typ": quran, set-qiraa, set-bracket, قرآن, ضبط_القراءة, تفعيل_الأقواس

#let package-meta = toml("../typst.toml").package

#let example(code) = {
  block(
    fill: luma(240),
    inset: 8pt,
    radius: 4pt,
    width: 100%,
    code
  )
}

#set document(title: "Quran Package Manual", author: package-meta.authors)
#set page(numbering: "1", number-align: center)
#set text(lang: "en")

#show heading: set block(below: 1em)

#align(center)[
  #text(size: 2em, weight: "bold")[#package-meta.name] \
  #text(size: 1.2em)[Version #package-meta.version] \
  #v(1em)
  A Typst package for rendering Quranic text.
]

#outline(indent: auto)

= Introduction
This package allows you to render Quranic text in Typst using the authentic fonts from the King Fahd Complex for the Printing of the Holy Quran. It supports both *Hafs* and *Warsh* readings.

= Prerequisites
To use this package, you must have the required fonts installed on your system or available in your project.

= Installation
Import the package using the following line:
#example[
```typ
#import "@preview/madinah-mushaf:0.1.0": quran, set-qiraa, set-bracket
```
]

= Usage

== Basic Rendering

Render a full Sura (e.g., Al-Ikhlas):
#example[
```typ
#quran(sura: 112)
```
]
#quran(sura: 112)

Render a specific Verse (e.g., Al-Fatiha, Verse 1):
#example[
```typ
#quran(sura: 1, verse: 1)
```
]
#quran(sura: 1, verse: 1)

== Ranges

Render a range of Verses:
#example[
```typ
#quran(sura: 1, verse: (1, 4))
```
]
#quran(sura: 1, verse: (1, 4))

Render a specific Word:
#example[
```typ
#quran(sura: 1, verse: 1, word: 2)
```
]
#quran(sura: 1, verse: 1, word: 2)

== Qira'at

Switch between *Hafs* (default) and *Warsh*.

#example[
```typ
#quran(sura: 93, verse: 4, qiraa: "warsh")
```
]
#quran(sura: 93, verse: 4, qiraa: "warsh")

== Brackets

You can enable or disable the decorative brackets.

#example[
```typ
#quran(sura: 1, verse: 1, bracket: false)
```
]
#quran(sura: 1, verse: 1, bracket: false)

= Arabic API

The package provides a fully localized Arabic API.

#example[
```typ
#قرآن(سورة: 112)
```
]
#قرآن(سورة: 112)
