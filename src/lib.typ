/// Renders Quranic text.
///
/// - sura (int): The Sura number (1-114).
/// - verse (int, array, none): The verse number (int) or range (array of two ints, e.g., (1, 3)). If none, the whole Sura is returned.
/// - word (int, array, none): The word number (int) or range (array of two ints, e.g., (1, 3)). If none, the whole verse is returned.
/// - qiraa (str, auto): The Qiraa to use ("hafs", "warsh", "حفص", "ورش"). If auto, uses the globally set qiraa.
#let (quran, قرآن, set-qiraa, ضبط_القراءة) = {
  let qiraa-state = state("quran-qiraa", "hafs")

  let quran-impl(sura, verse, word, qiraa) = {
    assert(
      qiraa == "hafs" or qiraa == "warsh" or qiraa == "حفص" or qiraa == "ورش",
      message: "Qiraa can either be hafs, warsh, حفص, or ورش.",
    )

    let mushaf = if qiraa == "hafs" or qiraa == "حفص" { json("hafs.json") } else { json("warsh.json") }

    assert(type(sura) == int and sura >= 1 and sura <= mushaf.len(), message: "Invalid Sura number: " + str(sura))

    let rlo = str.from-unicode(0x202E)
    let pdf = str.from-unicode(0x202C)
    let selected-sura = mushaf.at(sura - 1)
    let force-rtl(content) = rlo + content + pdf
    let wrap-word(w) = text(font: w.f, fallback: false)[#str.from-unicode(w.c)]

    if verse == none {
      assert(word == none, message: "If you specify words you must specify a verse too.")
      return force-rtl(
        selected-sura.flatten().map(wrap-word).join(" "),
      )
    }

    if type(verse) == int {
      assert(verse >= 1 and verse <= selected-sura.len(), message: "Invalid Verse number: " + str(verse))

      let words = selected-sura.at(verse - 1)

      if word == none {
        return force-rtl(words.map(wrap-word).join(" "))
      }

      let assert-word(word-idx) = assert(
        word-idx >= 1 and word-idx <= words.len(),
        message: "Invalid Word number: " + str(word-idx),
      )

      if type(word) == int {
        assert-word(word)
        return force-rtl(wrap-word(words.at(word - 1)))
      }

      if type(word) == array {
        if word.len() == 1 {
          let (start-idx) = word
          assert-word(start-idx)
          return force-rtl(
            words.slice(start-idx - 1).map(wrap-word).join(" "),
          )
        }

        if word.len() == 2 {
          let (left-idx, right-idx) = word

          assert(left-idx != right-idx, message: "Values in word range cannot be equal to each other.")

          let start-idx = calc.min(left-idx, right-idx)
          let end-idx = calc.max(left-idx, right-idx)

          assert-word(start-idx)
          assert-word(end-idx)

          return force-rtl(
            words.slice(start-idx - 1, end-idx).map(wrap-word).join(" "),
          )
        }

        panic(
          "Cannot pass "
            + str(word.len())
            + " values in word range. Word ranges can have either one or two values but not more.",
        )
      }
    }

    if type(verse) == array {
      assert(word == none, message: "Cannot specify words while having verse ranges.")

      let assert-verse(verse-idx) = assert(
        verse-idx >= 1 and verse-idx <= selected-sura.len(),
        message: "Invalid Verse number: " + str(verse-idx),
      )

      if verse.len() == 1 {
        let (start-idx) = verse
        assert-verse(start-idx)
        return force-rtl(
          selected-sura.slice(start-idx - 1).flatten().map(wrap-word).join(" "),
        )
      }

      if verse.len() == 2 {
        let (left-idx, right-idx) = verse

        assert(left-idx != right-idx, message: "Values in verse range cannot be equal to each other.")

        let start-idx = calc.min(left-idx, right-idx)
        let end-idx = calc.max(left-idx, right-idx)

        assert-verse(start-idx)
        assert-verse(end-idx)

        return force-rtl(
          selected-sura.slice(start-idx - 1, end-idx).flatten().map(wrap-word).join(" "),
        )
      }

      panic(
        "Cannot pass "
          + str(verse.len())
          + " values in verse range. Verse ranges can have either one or two values but not more.",
      )
    }

    panic("Unreachable.")
  }

  let quran(sura: none, verse: none, word: none, qiraa: auto) = context {
    let q = if qiraa == auto { qiraa-state.get() } else { qiraa }
    quran-impl(sura, verse, word, q)
  }

  let قرآن(سورة: none, آية: none, كلمة: none, قراءة: auto) = quran(sura: سورة, verse: آية, word: كلمة, qiraa: قراءة)

  let set-qiraa(qiraa) = qiraa-state.update(qiraa)

  let ضبط_القراءة(قراءة) = set-qiraa(قراءة)

  (quran, قرآن, set-qiraa, ضبط_القراءة)
}