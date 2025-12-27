/// Renders Quranic text.
///
/// - sura (int): The Sura number (1-114).
/// - verse (int, array, none): The verse number (int) or range (array of two ints, e.g., (1, 3)). If none, the whole Sura is returned.
/// - word (int, array, none): The word number (int) or range (array of two ints, e.g., (1, 3)). If none, the whole verse is returned.
/// - qiraa (str, auto): The Qiraa to use ("hafs", "warsh", "حفص", "ورش"). If auto, uses the globally set qiraa.
/// - bracket (bool, auto): Whether to wrap the text in Quranic brackets. If auto, uses the globally set preference (default: true).
#let (quran, قرآن, set-qiraa, ضبط_القراءة, set-bracket, تفعيل_الأقواس) = {
  let qiraa-state = state("quran-qiraa", "hafs")
  let bracket-state = state("quran-bracket", true)

  let rlo = str.from-unicode(0x202E)
  let pdf = str.from-unicode(0x202C)
  let force-rtl(content) = rlo + content + pdf

  let quran-impl(sura, verse, word, qiraa, bracket) = {
    let wrap-word(w) = {
      let variant = if qiraa == "hafs" or qiraa == "حفص" { "Hafs" } else { "Warsh" }
      let page = str(w.p)
      if page.len() == 1 { page = "0" + page }
      let font = "QCF4_" + variant + "_" + page + "_W"
      text(font: font, fallback: false)[#str.from-unicode(w.c)]
    }

    assert(
      qiraa == "hafs" or qiraa == "warsh" or qiraa == "حفص" or qiraa == "ورش",
      message: "Qiraa can either be hafs, warsh, حفص, or ورش.",
    )

    let mushaf = if qiraa == "hafs" or qiraa == "حفص" { json("hafs.json") } else { json("warsh.json") }

    let format-output(content) = {
      if bracket {
        let font = if qiraa == "hafs" or qiraa == "حفص" { "QCF4_Hafs_01_W" } else { "QCF4_Warsh_01_W" }
        let open = text(font: font, fallback: false)[#str.from-unicode(0xF8E0)]
        let close = text(font: font, fallback: false)[#str.from-unicode(0xF8E1)]
        force-rtl(open + content + close)
      } else {
        force-rtl(content)
      }
    }

    assert(type(sura) == int and sura >= 1 and sura <= mushaf.len(), message: "Invalid Sura number: " + str(sura))

    let selected-sura = mushaf.at(sura - 1)

    if verse == none {
      assert(word == none, message: "If you specify words you must specify a verse too.")
      return format-output(
        selected-sura.flatten().map(wrap-word).join(" "),
      )
    }

    if type(verse) == int {
      assert(verse >= 1 and verse <= selected-sura.len(), message: "Invalid Verse number: " + str(verse))

      let words = selected-sura.at(verse - 1)

      if word == none {
        return format-output(words.map(wrap-word).join(" "))
      }

      let assert-word(word-idx) = assert(
        word-idx >= 1 and word-idx <= words.len(),
        message: "Invalid Word number: " + str(word-idx),
      )

      if type(word) == int {
        assert-word(word)
        return format-output(wrap-word(words.at(word - 1)))
      }

      if type(word) == array {
        if word.len() == 1 {
          let (start-idx) = word
          assert-word(start-idx)
          return format-output(
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

          return format-output(
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
        return format-output(
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

        return format-output(
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

  let quran(sura: none, verse: none, word: none, qiraa: auto, bracket: auto) = context {
    let q = if qiraa == auto { qiraa-state.get() } else { qiraa }
    let b = if bracket == auto { bracket-state.get() } else { bracket }
    quran-impl(sura, verse, word, q, b)
  }

  let قرآن(سورة: none, آية: none, كلمة: none, قراءة: auto, أقواس: auto) = quran(sura: سورة, verse: آية, word: كلمة, qiraa: قراءة, bracket: أقواس)

  let set-qiraa(qiraa) = qiraa-state.update(qiraa)
  let set-bracket(enabled) = bracket-state.update(enabled)

  let ضبط_القراءة(قراءة) = set-qiraa(قراءة)
  let تفعيل_الأقواس(تفعيل) = set-bracket(تفعيل)

  (quran, قرآن, set-qiraa, ضبط_القراءة, set-bracket, تفعيل_الأقواس)
}
