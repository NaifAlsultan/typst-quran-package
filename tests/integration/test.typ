#import "/src/lib.typ": quran

#set page(width: auto, height: auto, margin: 1em)

// Explicitly set LTR to test that the package handles RTL enforcement internally
#set text(dir: ltr, lang: "en")

= Integration Tests

== 1. LTR Document Direction
This text is LTR. The Quranic text below should still be RTL.
#quran(sura: 112, verse: 1)

== 2. English Mixing (Inline)
The Quranic text #quran(sura: 1, verse: 1) should be embedded correctly between English words.

== 3. Arabic Mixing (Inline)
// We wrap this in an Arabic text block to ensure the surrounding text renders correctly as RTL,
// testing if the quran function plays nicely with existing RTL text.
#text(lang: "ar", dir: rtl)[
  بداية النص #quran(sura: 1, verse: 1) نهاية النص
]

== 4. Font Size Scaling
This text is normal size.
#text(20pt)[
  #quran(sura: 1, verse: 1)
]
(Should be 20pt)

== 5. Block Context
Testing the Quran text in its own block (centered).
#align(center)[
  #quran(sura: 112)
]