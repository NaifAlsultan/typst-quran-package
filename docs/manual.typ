#import "../src/lib.typ": quran, set-qiraa, set-bracket, قرآن, ضبط-القراءة, تفعيل-الأقواس

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

#set document(title: "Madinah Mushaf Package Manual", author: package-meta.authors)
#set page(numbering: "1", number-align: center)
#set text(lang: "en")

#show heading: set block(below: 1em)

#align(center)[
  #text(size: 2em, weight: "bold")[#package-meta.name] \
  #text(size: 1.2em)[Version #package-meta.version] \
  #v(1em)
  A Typst package for rendering Quranic text according to the Madinah Mushaf.
]

#outline(indent: auto)

= Introduction
This package allows you to render Quranic text in Typst using the authentic handwriting of calligrapher Uthman Taha from the *King Fahd Complex for the Printing of the Holy Quran*. It provides precise control over suras, verses, and individual words, supporting both *Hafs* (حفص) and *Warsh* (ورش) qira'at.

= Features
- *High Quality*: Uses authentic fonts from the King Fahd Complex.
- *Granular Control*: Render specific Suras, Verses, or Words.
- *Ranges*: Support for ranges of verses and words.
- *Multi-Qira'at*: Supports *Hafs* and *Warsh*.
- *Bilingual API*: Full support for both English and Arabic function names.

= Prerequisites
This package requires specific fonts to render the Quranic text properly. These fonts can be found in #link("https://github.com/NaifAlsultan/typst-quran-package/tree/main/fonts")[`fonts/`].

#block(fill: luma(240), inset: 8pt, radius: 4pt)[
  *Important:* Do not rename the font files (e.g., `QCF4_Hafs_01_W.ttf`). The package relies on these exact filenames.
]

You must make them available to Typst using one of the following methods:

+ *System Fonts:* Install the fonts found in #link("https://github.com/NaifAlsultan/typst-quran-package/tree/main/fonts/hafs")[`fonts/hafs/`] and #link("https://github.com/NaifAlsultan/typst-quran-package/tree/main/fonts/warsh")[`fonts/warsh/`] globally on your operating system.
+ *Specify Font Path:* Point Typst to the fonts directory using the `--font-path` argument when compiling:
  ```bash
  typst compile --font-path ./fonts your-file.typ
  ```

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

== Advanced Selection

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

Render a range of Words in a Verse:
#example[
```typ
#quran(sura: 1, verse: 1, word: (1, 2))
```
]
#quran(sura: 1, verse: 1, word: (1, 2))

== Qira'at

The package supports *Hafs* (default) and *Warsh*.

You can set the Qiraa globally:
#example[
```typ
#set-qiraa("warsh")
#quran(sura: 93, verse: 4)
```
]
#block[
  #set-qiraa("warsh")
  #quran(sura: 93, verse: 4)
]

Or specify it for a single call:
#example[
```typ
#quran(sura: 93, verse: 4, qiraa: "warsh")
```
]
#quran(sura: 93, verse: 4, qiraa: "warsh")

== Brackets

You can enable or disable the decorative brackets.

Disable brackets globally:
#example[
```typ
#set-bracket(false)
#quran(sura: 1, verse: 1)
```
]
#block[
  #set-bracket(false)
  #quran(sura: 1, verse: 1)
]

Control for a single call:
#example[
```typ
#quran(sura: 1, verse: 1, bracket: false)
```
]
#quran(sura: 1, verse: 1, bracket: false)

= Arabic API

The package provides a fully localized Arabic API.

#example[
#set text(dir: rtl)
```typ
#قرآن(سورة: 1, آية: 1)

// تغيير القراءة
#ضبط-القراءة("ورش")
#قرآن(سورة: 93, آية: 4)

// التحكم في الأقواس
#تفعيل-الأقواس(false)
#قرآن(سورة: 112, أقواس: true)
```
]

= Credits
- Fonts and Text: #link("https://qurancomplex.gov.sa/")[King Fahd Complex for the Printing of the Holy Quran].
