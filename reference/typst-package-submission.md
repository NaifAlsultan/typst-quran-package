---
Source: ./CATEGORIES.md
---

# Typst Package Categories

Categories help users explore packages, make finding the right one easier, and
provide package authors with a reference for best-practices in similar packages.
In addition to categories, packages can also specify a list of [disciplines]
describing their target audience.

Each package can declare itself a part of up to three categories.

There are two kinds of package categories: Functional categories that describe
what a package does on a technical level and publication categories that
describe for which kind of deliverable a package may be used.

Package authors are not required to pick a category from each of the two
groups. Instead, they can omit one group completely if it is not applicable to
their package, or use two categories for another group. Publication categories,
for example, are of big relevance to template packages and less so to a general
utility package that may apply to most publication kinds.

## Functional Categories

- **`components`:** Building blocks for documents. This includes boxes, layout
  elements, marginals, icon packs, color palettes, and more.
- **`visualization`:** Packages producing compelling visual representations of
  data, information, and models.
- **`model`:** Tools for managing semantic information and references. Examples
  could be glossaries and bibliographic tools.
- **`layout`:** Primitives and helpers to achieve advanced layouts and set up a
  page with headers, margins, and multiple content flows.
- **`text`:** Packages that transform text and strings or are focused on fonts.
- **`languages`:** Tools for localization and internationalization as well as
  dealing with different scripts and languages in the same document.
- **`scripting`:** Packages/libraries focused on the programmatic aspect of
  Typst, useful for automating documents.
- **`integration`:** Integrations with third-party tools and formats. In
  particular, this includes packages that embed a third-party binary as a
  plugin.
- **`utility`:** Auxiliary packages/tools, for example for creating
  compatibility and authoring packages.
- **`fun`:** Unique uses of Typst that are not necessarily practical, but
  always entertaining.

## Publication Categories

- **`book`:** Long-form fiction and non-fiction books with multiple chapters.
- **`report`:** A multipage informational or investigative document focused on
  a single topic. This category contains templates for tech reports, homework,
  proposals and more.
- **`paper`:** A scientific treatment on a research question. Usually published
  in a journal or conference proceedings.
- **`thesis`:** A final long-form deliverable concluding an academic degree.
- **`poster`:** A large-scale graphics-heavy presentation of a topic. A poster
  is intended to give its reader a first overview over a topic at a glance.
- **`flyer`:** Graphics-heavy, small leaflets intended for massive circulation
  and to inform or convince.
- **`presentation`:** Slides for a projected, oral presentation.
- **`cv`:** A résumé or curriculum vitæ presenting the author's professional
  achievements in a compelling manner.
- **`office`:** Staples for the day-to-day in an office, such as a letter or an
  invoice.

[disciplines]: https://github.com/typst/packages/blob/main/docs/DISCIPLINES.md



---
Source: ./DISCIPLINES.md
---

# Typst Package Disciplines

Disciplines define the target audience of a package, making it easy for users to
discover domain-specific packages and templates. Not all packages are
domain-specific, those can simply omit the `disciplines` key from their
manifest. In addition to disciplines, packages can also specify a list of
[categories] describing their functionality.

Disciplines are standardized for discoverability. If you want to submit a
domain-specific package, but there isn't a fitting discipline in the list below,
please reach out to us!

The following disciplines are currently defined:

- `agriculture`
- `anthropology`
- `archaeology`
- `architecture`
- `biology`
- `business`
- `chemistry`
- `communication`
- `computer-science`
- `design`
- `drawing`
- `economics`
- `education`
- `engineering`
- `fashion`
- `film`
- `geography`
- `geology`
- `history`
- `journalism`
- `law`
- `linguistics`
- `literature`
- `mathematics`
- `medicine`
- `music`
- `painting`
- `philosophy`
- `photography`
- `physics`
- `politics`
- `psychology`
- `sociology`
- `theater`
- `theology`
- `transportation`

[categories]: https://github.com/typst/packages/blob/main/docs/CATEGORIES.md



---
Source: ./documentation.md
---

# Writing package documentation

Packages must contain a `README.md` file documenting (at least briefly) what the
package does and all definitions intended for usage by downstream users.
Examples in the README should show how to use the package through a `@preview`
import. Also consider running [`typos`][typos] through your package before
release.

More complete documentation (usually written in Markdown, or in a PDF generated
from a Typst file) can be linked from this README. In general there are two
options for linking these resources:

If the resources are committed to this repository, you should link them locally.
For example like this: `[manual.pdf](docs/manual.pdf)`. Most of these files
should be excluded in your [manifest], see [what to exclude].

If the resources are stored elsewhere, you can link to their URL as usual. When
linking to files from another git repository, consider linking to a specific tag
or revision, instead of the `main` branch. This will ensure that the linked
resources always match the version of the package. So for example, prefer linking
to the first URL instead of the second one:
1. `https://github.com/micheledusi/Deckz/blob/v0.3.0/docs/manual-deckz.pdf`
2. `https://github.com/micheledusi/Deckz/blob/main/docs/manual-deckz.pdf`

If your package has a dedicated documentation website, it can be linked in the
README, but also via the `homepage` field of your [manifest].

## Differences from standard Markdown

Typst Universe processes your package README before displaying it,
in ways that differ from standard Markdown and from what GitHub or other
Git forges do. Here is what you need to know to make sure your README
will be displayed as expected.

The most visible processing that is done is to remove top-level headings: a web
page should only have a single `<h1>` tag for accessibility and SEO reasons, and
Typst Universe already shows the name of the package in such a heading.

Also note that some Markdown extensions that are present on GitHub, like
[alert blocks] or [emoji shortcodes] are not available on Typst Universe.

## Theme-responsive images

You can include images that will work with both light and dark theme in your README
using the following snippet:

```html
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="example-dark.png">
  <img alt="Example output" src="example-light.png">
</picture>
```

[typos]: https://github.com/crate-ci/typos
[manifest]: manifest.md
[what to exclude]: tips.md#what-to-commit-what-to-exclude
[alert blocks]: https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax#alerts
[emoji shortcodes]: https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax#using-emojis



---
Source: ./licensing.md
---

# Licensing your package

Packages must be licensed under the terms of an [OSI-approved][OSI] license or a
version of CC-BY, CC-BY-SA, or CC0. We recommend you do not license your package
using a Creative Commons license unless it is a derivative work of a
CC-BY-SA-licensed work or if it is not primarily code, but content or data. In
most other cases, [a free/open license specific to software is better suited for
Typst packages][cc-faq]. If different files in your package are under different
licenses, it should be stated clearly (in your README for example) which license
applies to which file.

In addition to specifying the license in the TOML manifest, a package must
either contain a `LICENSE` file or link to one in its `README.md`.

*Additional details for template packages:* If you expect the package
license's provisions to apply to the contents of the template directory (used
to scaffold a project) after being modified through normal use, especially if
it still meets the _threshold of originality,_ you must ensure that users of
your template can use and distribute the modified contents without
restriction. In such cases, we recommend licensing at least the template
directory under a license that requires neither attribution nor distribution
of the license text. Such licenses include MIT-0 and Zero-Clause BSD. You can
use an SPDX AND expression to selectively apply different licenses to parts of
your package. In this case, the README or package files must make clear under
which license they fall. If you explain the license distinction in the README
file, you must not exclude it from the package.

## Copyrighted material

Sometimes you may want to distribute assets which are not under an open-source
license, for example, the logo of a university. Typst Universe allows you to
distribute those assets only if the copyright holder has a policy that clears
distribution of the asset in the package.

If you are including such assets in your package, have your README clearly
indicate which files are not covered by the license given in the manifest file
and include or link to the relevant terms by the copyright holder.

[cc-faq]: https://creativecommons.org/faq/#can-i-apply-a-creative-commons-license-to-software
[OSI]: https://opensource.org/licenses/



---
Source: ./manifest.md
---

# Writing a package manifest

A Typst package should contain a file named `typst.toml`. It is called the
"package manifest" or "manifest" for short. This file contains metadata about
the package, such as its name, version or the names of its authors.

As suggested by the extension, manifest are written in [TOML].

## Package metadata

The only required section ("table" in TOML lingo) is named `package`
and contains most of the metadata about your package. Here is an example
of what it can look like.

```toml
[package]
name = "example"
version = "0.1.0"
entrypoint = "lib.typ"
authors = ["The Typst Project Developers"]
license = "MIT"
description = "Calculate elementary arithemtics with functions."
```

The following fields are required by the compiler:

- `name`: The package's identifier in its namespace. We have some specific rules
  for packages submitted to Typst Universe, detailed [below].
- `version`: The package's version as a full major-minor-patch triple.
  Package versioning should follow [SemVer].
- `entrypoint`: The path to the main Typst file that is evaluated when the
  package is imported.

If you plan to use your package only on your machine or to distribute
it by your own means, you don't have to include more than these three fields.
However, for your package to be published on Typst Universe, a few more fields
are required.

Required for submissions to this repository:

- `authors`: A list of the package's authors. Each author can provide an email
  address, homepage, or GitHub handle in angle brackets. The latter must start
  with an `@` character, and URLs must start with `http://` or `https://`.
- `license`: The package's license. Must contain a valid SPDX-2 expression
  describing one or multiple licenses. Please make sure to meet our [licensing
  requirements][license] if you want to submit your package to Typst Universe.
- `description`: A short description of the package. Double-check this for
  grammar and spelling mistakes as it will appear in the [package list][list].
  If you want some tips on how to write a great description, you can refer to
  [the dedicated section below][description].

Optional:

- `homepage`: A link to the package's web presence, where there could be more
  details, an issue tracker, or something else. Will be linked to from the
  package list. If there is no dedicated web page for the package, don't link to
  its repository here. Omit this field and prefer `repository`.
- `repository`: A link to the repository where this package is developed. Will
  be linked to from Typst Universe if there is no homepage.
- `keywords`: An array of search keywords for the package.
- `categories`: An array with up to three categories from the
  [list of categories][categories] to help users discover the package.
- `disciplines`: An array of [disciplines] defining the target audience for
  which the package is useful. Should be empty if the package is generally
  applicable.
- `compiler`: The minimum Typst compiler version required for this package to
  work.
- `exclude`: An array of globs specifying files that should not be part of the
  published bundle that the compiler downloads when importing the package. These
  files will still be available on typst universe to link to from the README.\
  To be used for large support files like images or PDF documentation that would
  otherwise unnecessarily increase the bundle size. Don't exclude the README or
  the LICENSE, see [what to exclude].

Packages always live in folders named as `{name}/{version}`. The name and
version in the folder name and manifest must match. Paths in a package are local
to that package. Absolute paths start in the package root, while relative paths
are relative to the file they are used in.

### Naming rules

Package names should not be the obvious or canonical name for a package with
that functionality (e.g. `slides` is forbidden, but `sliding` or `slitastic`
would be ok). We have this rule because users will find packages with these
canonical names first, creating an unfair advantage for the package author who
claimed that name. Names should not include the word "typst" (as it is
redundant). If they contain multiple words, names should use `kebab-case`. Look
at existing packages and PRs to get a feel for what's allowed and what's not.

*Additional guidance for template packages:* It is often desirable for template
names to feature the name of the organization or publication the template is
intended for. However, it is still important to us to accommodate multiple
templates for the same purpose. Hence, template names shall consist of a unique,
non-descriptive part followed by a descriptive part. For example, a template
package for the fictitious _American Journal of Proceedings (AJP)_ could be
called `organized-ajp` or `eternal-ajp`. Package names should be short and use
the official entity abbreviation. Template authors are encouraged to add the
full name of the affiliated entity as a keyword.

The unamended entity name (e.g. `ajp`) is reserved for official template
packages by their respective entities. Please make it clear in your PR if you
are submitting an official package. We will then outline steps to authenticate
you as a member of the affiliated organization.

If you are an author of an original template not affiliated with any
organization, only the standard package naming guidelines apply to you.

These rules also apply to names in other languages, including transliterations
for languages that are not generally written using the Latin alphabet.

### Writing a good description

A good package description is simple, easily understandable and succinct. Here
are some rules to follow to write great descriptions:

- Keep it short. Try to maximize the content to length ratio and weigh your words
  thoughtfully. Ideally, it should be 40 to 60 characters long.

- Terminate your description with a full stop.

- Avoid the word "Typst", which is redundant unless your package or template
  actually has to do with Typst itself or its ecosystem (like in the case of
  [mantys] or [t4t]).

- Avoid the words "package" for packages and "template" for templates; instead:
  - Packages allow the user to *do* things; use the imperative mood. For
    example, `Draw Venn diagrams.` is better than `A package for drawing Venn
    diagrams.`.
  - Templates allow the user to write certain *types* of documents; clearly
    indicate the type of document your template allows. For example, `Master’s
    thesis at the Unseen University.` is better than `A template for writing a
    master’s thesis at the Unseen University.`. Omit the indefinite article ("A
    …", "An …") at the beginning of the description for conciseness.

## Templates

Packages can act as templates for user projects. In addition to the module that
a regular package provides, a template package also contains a set of template
files that Typst copies into the directory of a new project.

In most cases, the template files should not include the styling code for the
template. Instead, the template's entrypoint file should import a function from
the package. Then, this function is used with a show rule to apply it to the
rest of the document.

Template packages (also informally called templates) must declare the
`[template]` key in their `typst.toml` file. A template package's `typst.toml`
could look like this:

```toml
[package]
name = "charged-ieee"
version = "0.1.0"
entrypoint = "lib.typ"
authors = ["Typst GmbH <https://typst.app>"]
license = "MIT-0"
description = "IEEE-style paper to publish at conferences and journals."

[template]
path = "template"
entrypoint = "main.typ"
thumbnail = "thumbnail.png"
```

Required by the compiler:

- `path`: The directory within the package that contains the files that should
  be copied into the user's new project directory.
- `entrypoint`: A path _relative to the template's path_ that points to the file
  serving as the compilation target. This file will become the previewed file in
  the Typst web application.

Required for submissions to this repository:

- `thumbnail`: A path relative to the package's root that points to a PNG or
  lossless WebP thumbnail for the template. The thumbnail must depict one of the
  pages of the template **as initialized.** The longer edge of the image must be
  at least 1080 px in length. Its file size must not exceed 3 MiB. Exporting a
  PNG at 250 PPI resolution is usually a good way to generate a thumbnail. You
  can use the following command for that: `typst compile -f png --pages 1 --ppi
  250 main.typ thumbnail.png`. You are encouraged to use [oxipng] to reduce the
  thumbnail's file size. The thumbnail will automatically be excluded from the
  package files and must not be referenced anywhere in the package.

Template packages must specify at least one category in `categories` (under the
`[package]` section).

If you're submitting a template, please test that it works locally on your
system. The recommended workflow for this is as follows:

- Add a symlink from `$XDG_DATA_HOME/typst/packages/preview` to the `preview`
  folder of your fork of this repository (see the documentation on [local
  packages]).
- Run `typst init @{namespace}/{name}:{version}`. Note that you must manually specify
  the version as the package is not yet in the index, so the latest version
  won't be detected automatically.
- Compile the freshly instantiated template.

## Third-party metadata

Third-party tools can add their own entry under the `[tool]` section to attach
their Typst-specific configuration to the manifest.

```toml
[package]
# ...

[tool.mytool]
foo = "bar"
```

[TOML]: https://toml.io/
[below]: #naming-rules
[list]: https://typst.app/universe/search/
[categories]: CATEGORIES.md
[disciplines]: DISCIPLINES.md
[mantys]: https://typst.app/universe/package/mantys/
[t4t]: https://typst.app/universe/package/t4t
[local packages]: ../README.md#local-packages
[SemVer]: https://semver.org/
[oxipng]: https://github.com/shssoichiro/oxipng
[license]: licensing.md
[description]: #writing-a-good-description
[what to exclude]: tips.md#what-to-commit-what-to-exclude



---
Source: ./README.md
---

# Package submission guidelines

Before creating and submitting your package, please carefully read through the
package submission guidelines listed below. These rules ensure that published
packages meet a certain quality standard and work properly for everyone.

- **Functionality:** Packages should conceivably be useful to other users and
  should expose their capabilities in a reasonable fashion.

- **Name:** We have somewhat unusual [naming rules] that all packages must
  adhere to. Please read them carefully. The naming rules ensure that multiple
  packages for the same purpose can co-exist without one having an unfair
  advantage.

- **Correctness:** Typst files and the manifest should not contain any syntax
  errors. More generally, your package should be importable without errors.
  (This does not mean that the package must be flawless; it's always possible
  for bugs to slip in. If you find a mistake or bug after the package is
  accepted, you can simply submit a patch release.) If your package includes a
  template, it should compile out-of-the-box. In particular, it should use the
  absolute package-style import and not a relative file import (i.e
  `@preview/my-package:0.1.0` rather than `../lib.typ`).

- **Documentation:** Your package must include a `README.md` file, documenting
  its purpose succinctly. This README should include examples, and may contain
  illustrations. Examples in the README and other documentation files should be
  up-to-date and compile. In particular, version numbers in package imports
  should be updated with each release. The contents of the README file will be
  displayed on Typst Universe.

- **Licensing:** The license provided in the package manifest should match the
  contents of the license file. The authors and copyright year in the license
  file should be correct. Your package should not contain any copyrighted
  material for which you don't have distribution rights.

- **Size:** Packages should not contain large files or a large number of files.
  This will be judged on a case-by-case basis, but any exception should be
  well-motivated. To keep the package small and fast to download, please
  `exclude` images for the README or PDF files with documentation from the
  bundle. For more detailed guidelines, please refer to [the "What to commit?
  What to exclude?"][exclusion] section.

- **Security and Safety:** Packages must not attempt to exploit the compiler or
  packaging implementation, in particular not to exfiltrate user data. Names and
  package contents must be safe for work.

If you don't meet our requirements, it may take a bit more time for your package
to be published, as we will ask you to make changes, but it will not prevent
your package from being published once the required changes are made.

Please note that the list above may be extended over time as improvements/issues
to the process are discovered. Given a good reason, we reserve the right to
reject any package submission.

## Package submission in practice

Once you checked that your package meets all the above criteria, make a pull
request with the package to this repository. Start by cloning the repository (we
recommend using a [sparse checkout][sparse-checkout]), and create a new
directory for your package named
`packages/{namespace}/{package-name}/{version}`. For now, the only allowed
namespace is `preview`. You can then [copy your package files][exclusion] here,
commit your changes and open a pull request.

> [!NOTE]
> The author of a package update should be the same person as the one
> who submitted the previous version. If not, the previous author will be asked
> before approving and publishing the new version.

We have collected tips to make your experience as a package author easier and to
avoid common pitfalls. They are split into the following categories:

- [The package manifest][manifest]
- [Typst files][typst] (including template and example files)
- [Images, fonts and other assets][resources]
- [The README file, and documentation in general][documentation]
- [Licensing][license] of your package
- [Further Tips][tips]

When a package's PR has been merged and CI has completed, the package will be
available for use. However, it can currently take up to 30 minutes until the package
will be visible on [Typst Universe][universe].

## Fixing or removing a package

Once submitted, a package will not be changed or removed without good reason to
prevent breakage for downstream consumers. By submitting a package, you agree
that it is here to stay. If you discover a bug or issue, you can of course
submit a new version of your package.

[sparse-checkout]: tips.md#sparse-checkout-of-the-repository
[exclusion]: tips.md#what-to-commit-what-to-exclude
[manifest]: manifest.md
[typst]: typst.md
[resources]: resources.md
[documentation]: documentation.md
[license]: licensing.md
[naming rules]: manifest.md#naming-rules
[tips]: tips.md
[universe]: https://typst.app/universe/



---
Source: ./resources.md
---

# Images, fonts and other resources

Typst packages can ship more than just code. This document explains how to
properly handle resource files and avoid common mistakes.

## Paths are package scoped

When reading external files, the path that is given to the function
(like `image`, `json` or `read`) is relative to the current file
and can only access files in the current package. This means it can't
access files from other packages. But more importantly, in case your package
is a template, it can't access files in the user's project.

For instance, let's say you have the following file hierarchy:

```
preview/my-template/1.0.0/
  README.md
  LICENSE
  typst.toml
  thumbnail.png
  src/
    lib.typ
  template/
    main.typ
    logo.png
```

In `lib.typ`, calling `image("../template/logo.png")` will seem to work.
But this won't refer to the copy of `logo.png` in the users project: if they
were to replace the provided logo with their own, your package would still use
the original one.

It also means that allowing for customization using a string parameter called `logo-path`
that is passed to `image` in your package won't work either: the file
access is made relatively to where the `image` function is called, not to where
the path string is created.

The proper way to let the people using your template overwrite the file to use
is to take `content` as an argument directly, not a `string`. For example, you should
replace this:

```typ
#let cover-page(logo-path: "logo.png", title) = {
  image(logo-path)
  heading(title)
}
```

With something like:

```typ
#let cover-page(logo: image("logo.png"), title) = {
  logo
  heading(title)
}
```

It is still possible to customize define some default values to configure how
the image is displayed (its width for example), using a `set image(..)` rule.

It will be possible to take paths as arguments directly, [once a dedicated
type exists][path-type].

## Fonts are not supported in packages

As of now, it is not possible to ship font files within a package. Fonts need to
be present in the user's project to be detected in the web app, or be included
with the `--font-path` argument on the command line, and a package can't
interfere with either of these.

Technically, it would be possible to ship fonts with templates by putting them into
the template directory and asking command line users to specify the correct
directory when compiling. But this experience would be suboptimal, and would
result in a lot of large font files being duplicated both in this repository and
in user projects. For these reasons, it is not allowed.

The current solution if your package requires specific fonts is simply to
document how to download them and use them in the web app or on the command
line.

This is not a perfect solution either. The situation will be improved in future Typst
versions.

## Licensing non-code assets

We have [specific guidelines][license] for licensing assets distributed in your
packages.

[path-type]: https://github.com/typst/typst/issues/971
[license]: licensing.md



---
Source: ./tips.md
---

# Tips for package authors

## Sparse checkout of the repository

Because the repository stores all versions of all packages that ever were
published, its size only grows with time. However, most of the time, you will
only work in a few specific directories (the ones for your own packages). Git
allows for "sparse checkouts", which reduce the time it takes to clone the
repository and its size on your disk.

First, make sure you have forked the repository to your own GitHub account.
Then, follow these steps to clone the repository:

```sh
git clone --depth 1 --no-checkout --filter="tree:0" git@github.com:{your-username}/packages
cd packages
git sparse-checkout init
git sparse-checkout set packages/preview/{your-package-name}
git remote add upstream git@github.com:typst/packages
git config remote.upstream.partialclonefilter tree:0
git checkout main
```

The `packages` directory you are in still corresponds to the whole repository.
Do not delete or edit the `README.md`, `LICENSE` or any other file at the root.
Instead, create the directory `packages/preview/{your-package-name}/{version}`
and copy your files here. Note that `packages/` is a directory in the
`packages` repository: if you look at the full path, there should be two
consecutive parts called `packages`.

## Don't use submodules

The Typst package repository requires the files to be actually copied
to their respective directory, they should not be included as Git submodules.

When copying a package from another Git repository, you should not copy the
`.git` folder, otherwise when creating a commit to publish your package,
Git will replace the copied files with a submodule.

## What to commit? What to exclude?

In some case, simply copying and pasting the contents of the repository in which
you developed your package to a new directory in this repository is enough to
publish a package. However, this naive approach may result in unnecessary files
being included, making the size of this repository and of the final archives
larger than they need to be.

There are two solutions to limit this problem: excluding files from the archive
(using the `exclude` key in your [package manifest][manifest]), or simply not
committing the files to this repository in the first place.

To know which strategy to apply to each file, we can split them in three groups:

__1. Required files__\
Files that are necessary for the package to work. If any of these files are
removed, the package would break for the end user. This includes the manifest
file, main Typst file and its dependencies, and in case of a template package,
any file in the template directory.

__2. Documentation files__\
Files that are necessary for the package to be displayed correctly on Typst
Universe. This includes the README, and any files that are linked from there
(manuals, examples, illustrations, etc.). These files can easily be accessed
by opening the package README.

__3. Other files__\
This generally includes test files, build scripts, but also examples or manuals
that are not linked in the README. These files would be almost impossible to
access for the final user, unless they browse this GitHub repository or their
local package cache.

The first two groups (required and documentation files) should be committed to
this repository. And files that are not strictly necessary for the package to
work (documentation files) should be excluded in `typst.toml`. They will still
be available on typst universe to link to from the README.\
The third group should simply not be committed to this repository. If you think
some of the remaining files are important, they probably belong to the second
group and should be linked in the README, so that they are easily discoverable.
A good example showing how to link examples and a manual is [CeTZ][cetz].

The only exceptions to this rule are the LICENSE file (that should always be
available along with the source code, so it should not be excluded), and the
README (which is generally a lightweight file, and can provide minimal
documentation in case the user is offline or can't access anything else than
their local package cache for some other reason).

Also note that there is no need to exclude template thumbnails: they are
automatically left out of the archive.

## Tools that can be useful

The community created some tools that can help when developing your package:

- [typst-package-check], to lint your package.
- [tytanic], to test your packages.
- [typship], to easily install your package locally or submit it to Typst Universe.
- [showman], to help you document and publish your package.

[cetz]: https://typst.app/universe/package/cetz/0.3.4
[typst-package-check]: https://github.com/typst/package-check
[tytanic]: https://typst-community.github.io/tytanic/
[typship]: https://github.com/sjfhsjfh/typship
[showman]: https://github.com/ntjess/showman
[manifest]: manifest.md



---
Source: ./typst.md
---

# Writing high-quality Typst files

No specific code style is mandated, but two spaces of indent and kebab-case for
variable and function names are recommended. There can be exceptions (for
instance it can make sense to have a variable called `Alpha` and not `alpha`)
and if you have a strong preference for camelCase or snake_case, it can be
accepted.

## Use package specifications in imports

When writing example files, it is better to use the full package
specification when importing your own package, instead of relative imports. The
reasoning here is that it should be possible to copy any provided file as is and
start working from that. In other words, it is better to write:

```typ
#import "@preview/my-package:1.0.0": my-function
```

than:

```typ
#import "../lib.typ": my-function
```

For template files, this is not only a recommendation but a requirement. Users
should never have to edit a project freshly created from a template to make it
compile.

This recommendation does not apply to files that are directly part of the package
however, as this could cause a cyclic import.

## Only exposing specific functions publicly

When writing your package, you will probably create internal functions and
variables that should not be accessible to the end user. However, Typst
currently doesn't provide any keyword to indicate that a given binding should be
public or private, as most other programming languages do.

Fortunately, there is an easy pattern to select specific items to be public, and
keep the rest private to your package: instead of putting actual code in the
entrypoint of the package, simply import the items you want to be public from
other files.

Let's look at an example. Here is my `package.typ` file:

```typ
#let private(a, b) = a + b
#let public(a, b, c) = private(a, b) * private(b, c)
```

Then, if your package entrypoint is set to `lib.typ`, you can chose what
to export to the user by writing the following in `lib.typ`:

```typ
#import "package.typ": public
```

The user won't be able to call the `private` function, but can access the one
named `public` as they wish.

## Template customization

When providing a template, it is often desirable to let users customize the
styles you provide. You may also want to let them override the default contents
you provide (for example, what elements are shown on the title page and how they
are displayed).

However, the way Typst templates currently work, this code often lives in the
library part of the package, that is not copied to the users project, and thus
cannot be modified to fit their needs. Only placeholder configuration and
content is generally part of the template code that the user can edit in their
own project.

There is no proper solution to that problem for now. In the future, types
and custom elements will be a good way to give user control over the template
contents and appearance if they need, while providing good defaults.



