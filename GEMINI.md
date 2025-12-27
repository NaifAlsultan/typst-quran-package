# Typst Quran Package Context

## Project Overview
This project is a **Typst package** designed to render Quranic text according to the Madinah Mushaf. It uses authentic handwriting fonts from the **King Fahd Complex for the Printing of the Holy Quran**.

**Key Features:**
*   **Data Sources:** JSON-based datasets for Hafs (`src/hafs.json`) and Warsh (`src/warsh.json`) readings.
*   **Fonts:** Relies on specific font files located in `fonts/` (`hafs/` and `warsh/` subdirectories).
*   **API:** Bilingual API (English/Arabic) for selecting Suras, Verses, and Words.
*   **Formatting:** Configurable output formatting, including optional Quranic brackets.
*   **Testing:** Uses `tytanic` (binary `tt`) for regression testing.

## Directory Structure

*   **`src/`**: Contains the package logic.
    *   `lib.typ`: Main entry point. Contains the logic for parsing arguments and mapping them to the JSON data and specific fonts.
    *   `*.json`: Data files containing the Quranic text and font mappings.
*   **`fonts/`**: Contains the necessary `.ttf` files. **Crucial:** These must be visible to the Typst compiler (via `--font-path` or system installation) for the package to work.
*   **`tests/`**: Regression tests managed by `tytanic`.
    *   `render-hafs/`: Tests for the Hafs reading.
    *   `render-warsh/`: Tests for the Warsh reading.
    *   `brackets/`: Tests for bracket toggling behavior.
*   **`docs/`**: Documentation source (`manual.typ`) and assets.
*   **`scripts/`**: Shell scripts for packaging and local installation.

## Development & Usage

### Prerequisites
*   **Typst**: The compiler.
*   **Tytanic (`tt`)**: For running tests. Comprehensive documentation on how to use the Tytanic test runner can be found in `reference/tytanic-docs.md`. Refer to this file whenever help with Tytanic is needed.
*   **Just**: Command runner.
*   **Fonts**: The project relies on local fonts. When running commands, ensure `TYPST_FONT_PATHS` includes the `fonts/` directory, or pass `--font-path ./fonts`.

### Common Commands (via `Justfile`)

*   **Run Tests:**
    ```bash
    export TYPST_FONT_PATHS="$PWD/fonts"
    just test
    # OR direct usage
    tt run
    ```
*   **Update Test References:**
    ```bash
    export TYPST_FONT_PATHS="$PWD/fonts"
    just update
    # OR direct usage
    tt update
    ```
*   **Build Documentation:**
    ```bash
    just doc
    ```
*   **Install Locally:**
    ```bash
    just install
    ```
    *Installs the package to the system's local Typst package repository under `@local`.*

### Coding Conventions
*   **Style:** Follows standard Typst formatting.
*   **Testing:** New features *must* have accompanying visual regression tests in `tests/`. Use `tt new <test-name>` to generate boilerplate.
*   **Localization:** Maintain parity between the English (`quran`) and Arabic (`قرآن`) APIs.

### Configuration
*   **`typst.toml`**: Package metadata.
