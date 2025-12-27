#import "/src/lib.typ": quran, قرآن

#set page(width: auto, height: auto, margin: 1em)
#set text(lang: "ar")

= Hafs Rendering Tests

== Full Sura (Al-Ikhlas)
#quran(sura: 112)

== Single Verse (Al-Fatiha 1:1)
#quran(sura: 1, verse: 1)

== Verse Range (Al-Fatiha 1:1-3)
#quran(sura: 1, verse: (1, 3))

== Single Word (Al-Fatiha 1:1:2)
#quran(sura: 1, verse: 1, word: 2)

== Word Range (Al-Fatiha 1:1:1-2)
#quran(sura: 1, verse: 1, word: (1, 2))

== Arabic API (Sura An-Nas)
#قرآن(سورة: 114)
