#import "/src/lib.typ": quran, set-qiraa, ضبط-القراءة

#set page(width: auto, height: auto, margin: 1em)
#set text(lang: "ar")

= Warsh Rendering Tests

== Global Set Warsh (Sura 93:4)
#set-qiraa("warsh")

#quran(sura: 93, verse: 4)

== Explicit Parameter Hafs (Sura 93:4)
#quran(sura: 93, verse: 4, qiraa: "hafs")

== Arabic API Set Qira'at (Sura 93:4)

=== Global Set Hafs

#ضبط-القراءة("حفص")

#quran(sura: 93, verse: 4)

=== Explicit Parameter Warsh (Sura 93:4)

#quran(sura: 93, verse: 4, qiraa: "ورش")
