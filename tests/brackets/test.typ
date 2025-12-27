#import "/src/lib.typ": quran, set-bracket

#set page(width: auto, height: auto)
#set text(lang: "ar", dir: rtl)

= Test Brackets

== Default (Should have brackets)
#quran(sura: 1, verse: 1)

== Disable Global (Should NOT have brackets)
#set-bracket(false)
#quran(sura: 1, verse: 1)

== Local Override True (Should have brackets)
#quran(sura: 1, verse: 1, bracket: true)

== Enable Global (Should have brackets)
#set-bracket(true)
#quran(sura: 1, verse: 1)

== Local Override False (Should NOT have brackets)
#quran(sura: 1, verse: 1, bracket: false)

== Warsh (Should have brackets with Warsh font)
#quran(sura: 1, verse: 1, qiraa: "warsh")
