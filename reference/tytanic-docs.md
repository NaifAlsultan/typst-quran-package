---
Source: ./guides/ci.md
---

# Setting Up CI
Continuous integration can take a lot of manual work off of your shoulders.
In this chapter we'll look at how to run Tytanic in your GitHub CI to continuously test your code and catch bugs before they get merged into your project.

<div class="warning">

If you simply want to get CI working without any elaborate explanation, skip ahead to the bottom and copy the full file.

There's a good chance that you can simply copy and paste the workflow as is and it'll work, but the guide should give you an idea on how to adjust it to your liking.

</div>

We start off by creating a `.github/workflows` directory in our project and place a single `ci.yaml` file in this directory.
The name is not important, but should be something that helps you distinguish which workflow you're looking at.

First, we configure when CI should be running:
```yml
name: CI
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
```

The `on.push` and `on.pull_request` fields both take a `branches` fields with a single pattern matching our main branch, this means that this workflow is run on pull requests and pushes to main.
We could leave out the `branches` field and it would apply to all pushes or pull requests, but this is seldom useful.
If you have branch protection, you may not need the `on.push` trigger at all, if you're paying for CI this may save you money.

Next, let's add the test job we want to run, we'll let it run on `ubuntu-latest`, that's a fairly common runner for CI jobs.
More often than not, you won't need matrix or cross platform tests for Typst projects as Typst takes care of the OS differences for you.
Add this below the job triggers:

```yml
# ...

jobs:
  tests:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
```

This adds a single step to our job (called `tests`), which checks out the repository, making it available for the following steps.

We'll use `taiki-e/install-action` for downloading Tytanic, it uses `cargo-binstall`, which downloads the release binaries directly from GitHub.
The latest version of Tytanic is `0.3.3`, which targets Typst `0.14.x`.

```yml
steps:
  # ...
  - name: Install tytanic
    uses: taiki-e/cache-cargo-install-action@v2
    with:
      tool: tytanic@0.3.3

```

Then we're ready to run our tests, that's as simple as adding a step like so:

```yml
steps:
  # ...
  - name: Run test suite
    run: tt run --no-fail-fast
```

CI may fail for various reasons, such as
- missing fonts
- system time dependent test cases
- or otherwise hard-to-debug differences between the CI runner and your local machine.

To make it easier for you to actually get a grasp at the problem you should make the results of the test run available.
You can do this by using an upload action, however, if Tytanic fails the step will cancel all regular steps after itself, so you need to ensure it runs regardless of test failure or success by using `if: always()`.
The action then uploads all artifacts since some tests may produce both references and output on-the-fly and retains them for 5 days:

```yml
steps:
  # ...
  - name: Archive artifacts
    uses: actions/upload-artifact@v4
    if: always()
    with:
      name: artifacts
      path: |
        tests/**/diff/*.png
        tests/**/out/*.png
        tests/**/ref/*.png
      retention-days: 5
```

And that's it, you can add this file to your repo, push it to a branch and open a PR, the PR will already start running the workflow for you and you can adjust and debug it as needed.

> The full workflow file:
>
> ```yml
> name: CI
> on:
>   push:
>     branches: [ main ]
>   pull_request:
>     branches: [ main ]
>
> jobs:
>   tests:
>     runs-on: ubuntu-latest
>     steps:
>       - name: Checkout
>         uses: actions/checkout@v4
>
>       - name: Install tytanic
>         uses: taiki-e/cache-cargo-install-action@v2
>         with:
>           tool: tytanic@0.3.3
>
>       - name: Run test suite
>         run: tt run
>
>       - name: Archive artifacts
>         uses: actions/upload-artifact@v4
>         if: always()
>         with:
>           name: artifacts
>           path: |
>             tests/**/diff/*.png
>             tests/**/out/*.png
>             tests/**/ref/*.png
>           retention-days: 5
> ```



---
Source: ./guides/test-sets.md
---

# Using Test Sets
## Why Tests Sets
Many operations such as running, comparing, removing or updating tests all need to somehow select which tests to operate on.
Tytanic offers a functional set-based language which is used to select tests, it visually resembles writing a predicate which is applied to each test.

Test set expressions are passed using the `--expression` or `-e` flag, they support the following features:
- Binary and unary operators like `&`/`and` or `!`/`not`.
- Built-in primitive test sets such as `ephemeral()`, `compile-only()` or `skip()`.
- Identity test sets for easier scripting like `all()` and `none()`.
- Identifier pattern such as `regex:foo-\d{2}`.

This allows you to concisely filter your test suite without having to remember a number of hard-to-compose CLI options. [^ref]

## An Iterative Example
Suppose you had a project with the following tests:
```txt
tests
├─ features
│  ├─ foo1      persistent   skipped
│  ├─ foo2      persistent
│  ├─ bar       ephemeral
│  └─ baz       compile-only
├─ regressions
│  ├─ issue-42  ephemeral    skipped
│  ├─ issue-33  persistent
│  └─ qux       compile-only
└─ frobnicate   compile-only
```

You can use `tt list` to ensure your test set expression is correct before running or updating tests.
This is not just faster, it also saves you the headache of losing a test you accidentally deleted.

If you just run `tt list` without any expression it'll use `all()` and you should see:
```txt
features/foo2
features/bar
features/baz
regressions/issue-33
regressions/qux
frobnicate
```

You may notice that we're missing two tests, those marked as `skipped` above:
- `features/foo1`
- `regressions/issue-42`

If you want to refer to these skipped tests, then you need to pass the `--no-skip` flag, otherwise the expression is wrapped in `(...) ~ skip()` by default.
If you pass tests by name explicitly like `tt list features/foo1 regressions/issue-42`, then this flag is implied.

Let's say you want to run all tests, which are either ephemeral or persistent, i.e. those which aren't compile-only, then you can use either `ephemeral() | persistent()` or `not compile-only()`.
Because there are only these three kinds at the moment those are equivalent.

If you run
```shell
tt list -e 'not compile-only()'
```
you should see
```txt
features/foo1
features/foo2
features/bar
regressions/issue-42
regressions/issue-33
```

Then you can simply run `tt run` with the same expression and it will run only those tests.

If you want to include or exclude various directories or tests by identifier you can use patterns.
Let's say you want to only run feature tests, you can a pattern like `c:features` or more correctly `r:^features`.

If you run
```shell
tt list -e 'r:^features'
```
you should see
```txt
features/foo1
features/foo2
features/bar
features/baz
```

Any combination using the various operators also works.
If you wanted to only compile those tests which are both in `features` and are not `compile-only`, then you would combine them with an intersection, i.e the `and`/`&` operator.

If you run
```shell
tt list -e 'not compile-only() and r:^features'
```
you should see
```txt
features/baz
```

If you wanted to include all tests which are either you'd use the union instead:

If you run
```shell
tt list -e 'not compile-only() or r:^features'
```
you should see
```txt
features/foo1
features/foo2
features/bar
features/baz
regressions/qux
frobnicate
```

If you update or remove tests and the test set evaluates to more than one test, then you must either specify the `all:` prefix in the test set expression, or confirm the operation in a terminal prompt.

## Patterns
Note that patterns come in two forms:
- Raw patterns: They are provided for convenience, they have been used in the examples above and are simply the pattern kind followed by a colon and any non-whitespace characters.
- String patterns: A generalization which allows for whitespace and other ambiguous cases.

This distinction is useful for scripting and some interactive use cases.
String patterns have delimiters with which any ambiguities can be avoided, but they require more careful consideration of shell interpolation rules.

## Scripting
If you build up test set expressions programmatically, consider taking a look at the built-in test set functions.
Specifically the `all()` and `none()` test set constructors can be used as identity sets for certain operators, possibly simplifying the code generating the test sets.

Some of the syntax used in test sets may interfere with your shell, especially the use of whitespace and special tokens within patterns like `$` in regexes.
Use non-interpreting quotes around the test set expression (commonly single quotes `'...'`) to avoid interpreting them as shell specific sequences.

This should give you a rough overview of how test sets work, you can check out the [reference] to learn which operators, patterns, and test sets exist.

[reference]: ../reference/test-sets/index.html



---
Source: ./guides/tests.md
---

# Writing tests
To start writing tests, you only need to write regular `typst` scripts, no special syntax or annotations are required.

Let's start with the most common type of tests, unit tests.
We'll assume you have a normal package directory structure:
```txt
<project>
├─ src
│  └─ lib.typ
└─ typst.toml
```

## Unit tests
Unit tests are found in the `tests` directory of your project (remember that this is where your `typst.toml` manifest is found).

Let's write our first test, you can run `tt new my-test` to add a new unit test, this creates a new directory called `my-test` inside `tests` and adds a test script and reference document.
This test is located in `tests/my-test/tests.typ` and is the entry-point script (like a `main.typ` file).
Assuming you passed no extra options to `tt new`, this test is going to be a `persistent` unit test, this means that its output will be compared to a reference document which is stored in `tests/my-test/ref/` as individual pages.

You could also pass `--ephemeral`, which means to create a script which creates this document on every test run or `--compile-only`, which means the test doesn't create any output and is only compiled.

Your project will now look like this:
```txt
<project>
├─ src
│  └─ lib.typ
├─ tests
│  └─ my-test
│     ├─ ref
│     │  └─ 1.png
│     └─ test.typ
└─ typst.toml
```

If you now run
```shell
tt run my-test
```
you should see something along the lines of
```txt
  Starting 1 tests (run ID: 4863ce3b-70ea-4aea-9151-b83e25f11c94)
      pass [ 0s  38ms 413µs] my-test
──────────
   Summary [ 0s  38ms 494µs] 1/1 tests run: all 1 passed
```

This means that the test was run successfully.

Let's edit the test to actually do something, right now it simply contains `Hello World`.
Write something else in there and see what happens:
```diff
-Hello World
+Typst is Great!
```

Once we run Tytanic again we'll see that the test no longer passes:

```txt
  Starting 1 tests (run ID: 7cae75f3-3cc3-4770-8e3a-cb87dd6971cf)
      fail [ 0s  44ms 631µs] my-test
           Page 1 had 1292 deviations
           hint: Diff images have been saved at '<project>/test/tests/my-test/diff'
──────────
   Summary [ 0s  44ms 762µs] 1/1 tests run: all 1 failed
```

Tytanic has compared the reference output from the original `Hello World` document to the new document and determined that they don't match.
It also told you where you can inspect the difference, the `<project>/tests/my-test` contains a `diff` directory.
You can take a look to see what changed, you can also take a look at the `out` and `ref` directories, these contain the output of the current test and the expected reference output respectively.

Well, but this wasn't a mistake, this was a deliberate change.
So, let's update the references to reflect that and try again.
For this we use the appropriately named `update` command:

```bash
tt update my-test
```

You should see output similar to

```txt
  Starting 1 tests (run ID: f11413cf-3f7f-4e02-8269-ad9023dbefab)
      pass [ 0s  51ms 550µs] my-test
──────────
   Summary [ 0s  51ms 652µs] 1/1 tests run: all 1 passed
```

and the test should once again pass.

This test is still somewhat arcane, let's actually test something interesting, like the API of your fancy package.

Let's say you have this function inside your `src/lib.typ` file:

```typst
/// Frobnicates a value.
///
/// -> content
#let frobnicate(
  /// The argument to frobnicate, cannot be `none`.
  ///
  /// -> any
  arg
) = {
  assert.ne(type(arg), type(none), message: "Cannot frobnicate `none`!")

  [Frobnicating #arg]
}
```

Because Tytanic comes with a custom standard library you can catch panics and extract their messages to ensure your code also works in the failure path.

Let's add another test where we check that this function behaves correctly and let's not return any output but instead just check how it behaves with various inputs:

```shell
tt new --compile-only frobnicate
```

You project should now look like this:
```txt
<project>
├─ src
│  └─ lib.typ
├─ tests
│  ├─ my-test
│  │  ├─ ref
│  │  │  └─ 1.png
│  │  └─ test.typ
│  └─ frobnicate
│     └─ test.typ
└─ typst.toml
```

Note that the `frobnicate` test does not contain any other directories for references.
Because this test is within the project root it can access the projects internal files, even if they aren't reachable from the package entrypoint.

Let's import our function and test it:
```typst
#import "/src/lib.typ": frobnicate

// Passing `auto` should work:
#frobnicate(auto)

// We could even compare it:
#assert.eq(frobnicate("Strings work!"), [Frobnicate #"Strings work!"])
#assert.eq(frobnicate[Content works!], [Frobnicate Content works!])

// If we pass `none`, then this must panic, otherwise we did something wrong.
#assert-panic(() => frobnicate(none))

// We can also unwrap the panics and inspect their error message.
// Note that we get an array of strings back if a panic occurred, or `none` if
// there was no panic.
#assert.eq(
  catch(() => frobnicate(none)),
  "panicked with: Cannot frobnicate `none`!",
)
```

<div class="warning">

The exact interface of this library may change in the future.

See [#73].

</div>

<!--
The more your project grows
-->

## Template tests
Template packages automatically have an additional test for the configured template path called `@template`, this test cannot be created or removed.
These tests don't get access to the augmented standard library unit tests get, but in turn get the ability to access an unreleased version of the current package.

If you have a template like so:
```typst
#import "@preview/foo-bar:0.1.0"

// ...
```

Even if `foo-bar:0.1.0` is not yet released, it can be accessed for this particular test.
Template tests ensure that users can run `typst init @preview/foo-bar` without being stuck with a broken starting document.

## Documentation tests

<div class="warning">

In the future you'll be able to automatically test your documentation examples too, but these are currently unsupported

See [#34].

</div>

This should equip you with all the knowledge of how to reliably test your projects, but if you're still curious about all the details check out the [reference for tests][tests].

[#73]: https://github.com/typst-community/tytanic/issues/73
[#49]: https://github.com/typst-community/tytanic/issues/49
[#34]: https://github.com/typst-community/tytanic/issues/34
[tests]: ../reference/tests/index.html
[oxipng]: https://github.com/shssoichiro/oxipng



---
Source: ./guides/watching.md
---

# Watching for Changes
Tytanic does not currently support a `watch` sub command the same way `typst` does.
However, you can work around this by using [`watchexec`] or an equivalent tool which re-runs Tytanic whenever a file in your project changes.

Let's look at a concrete example with `watchexec`.
Navigate to your project root directory, i.e. that which contains your `typst.toml` manifest and run:
```shell
watchexec \
  --watch . \
  --clear \
  --ignore 'tests/**/diff/**' \
  --ignore 'tests/**/out/**' \
  --ignore 'tests/**/ref/**' \
  "tt run"
```

Of course a shell alias or task runner definition makes this more convenient.
While this is running, any change to a file in your project which is not excluded by the patterns provided using the `--ignore` flag will trigger a re-run of `tt run`.

If you have other files you may edit which don't influence the outcome of your test suite, then you should ignore them too.

<div class="warning">

Keep in mind that `tt run`, will run _all_ on every change, so this may not be appropriate for you if you have a large test suite.

</div>

[`watchexec`]: https://watchexec.github.io/



---
Source: ./quickstart/install.md
---

# Installation
## Versions
You can either install a stable version or a nightly version, a stable version uses a version tag like `v0.1.3`, whereas nightly versions are simply whatever is currently pointed to by the `main` branch on the GitHub repository.

Nightly has the newest features, but may have unfixed bugs or rough edges, use this with caution and back up your tests.

Once installed you will have a `tt` binary available, make sure to have a look at [Dependencies](#dependencies) if running Tytanic spits out some error about dynamic libraries.

## Methods
### Download from GitHub
You can download pre-built binaries of all stable versions from the [release page][releases] of the GitHub repository, these are automatically built for Linux, macOS, and Windows.
Nightly versions are not pre-built.

After you downloaded the correct archive for your operating system and architecture you have to extract them and place the `tt` binary somewhere in your `$PATH`.

### Using cargo-binstall
The most straight forward way to install Tytanic is to use `cargo-binstall`, this saves you the hassle of compiling from source:
```shell
cargo binstall tytanic
```

This methods requires `cargo-binstall` to be installed.

<div class="warning">

Installing via `cargo-binstall` will not work for versions `v0.1.2` or earlier.

You can use one of the other installation methods for those versions.

</div>

### Installation From Source
To install Tytanic from source, you must have a Rust toolchain (Rust **v1.89.0+**) and `cargo` installed, you can get these using [`rustup`][rustup].

#### Stable
```shell
cargo install --locked tytanic@0.3.3
```

#### Nightly
```shell
cargo install --locked --git https://github.com/typst-community/tytanic
```

This method usually doesn't require manually placing the `tt` binary in your `$PATH` because the cargo binary directory should already be in there.

### Nix Flake
#### Stable
```shell
nix run github:typst-community/tytanic/v0.3.3
```

#### Nightly
```shell
nix run github:typst-community/tytanic
```

This method doesn't require any extraction or `$PATH` modifications.

### Using docker
Every release is automatically added to the GitHub Container Registry `ghcr.io` and can be pulled like so:
```shell
docker pull ghcr.io/typst-community/tytanic:v0.3.3
```

Check out the [package][docker] for platform specific builds.

<div class="warning">

There are no package releases for versions `v0.1.1` or earlier.

You can use one of the other installation methods for those versions.

</div>

## Dependencies
The following dependencies are required for running Tytanic, though they are widely used and should in most cases already be installed if you used `typst` before.
Tytanic tries to provide feature flags for vendoring dependencies where possible.

### OpenSSL
OpenSSL (**v1.0.1** to **v3.x.x**) or LibreSSL (**v2.5** to **v3.7.x**) are required to allow Tytanic to download packages from the [Typst Universe][universe] package registry.

When installing from source the `vendor-openssl` feature can be used on Unix-like operating systems to vendor OpenSSL.
This avoids the need for it on the operating system.

[releases]: https://github.com/typst-community/tytanic/releases/
[rustup]: https://www.rust-lang.org/tools/install
[docker]: https://github.com/users/typst-community/packages/container/tytanic
[universe]: https://typst.app/universe



---
Source: ./quickstart/usage.md
---

# Usage
Tytanic is a command line program, it can be run by simply invoking it in your favorite shell and passing the appropriate arguments, the binary is called `tt`.

If you open a shell in the folder `project` and Tytanic is at `project/bin/tt`, then you can run it using `./project/bin/tt`.
Placing it directly in your project is most likely not what you want to do.
You should install it to a directory which is contained in your `$PATH`, allowing you to simply run it using `tt` directly.
How to add such folders to your `PATH` depends on your operating system, but if you installed Tytanic using one of the recommended methods in [Installation](./install.md), then such a folder should be chosen for you automatically.

Tytanic will look for the project root by checking for directories containing a `typst.toml` manifest file.
This is because Tytanic is primarily aimed at developers of packages.
If you want to use a different project root, or don't have a manifest file, you can provide the root directory using the `--root` like so.

```bash
tt list --root ./path/to/root/
```

Keep in mind that you must pass this option to every command that operates on a project.
Alternatively the `TYPST_ROOT` environment variable can be set to the project root.

Further examples assume the existence of a manifest, or the `TYPST_ROOT` variable being set
If you're just following along and don't have a package to test this with, you can use an empty project with the following manifest:

```toml
[package]
name = "foo"
description = "A fancy Typst package!"
version = "0.1.0"
authors = ["John Doe"]
license = "MIT"

entrypoint = "src/lib.typ"
```

Once you have a project root to work with you can run various commands like `tt new` or `tt run`.
Check out the [tests guide][guide] to find out how you can test your code.

[guide]: ../guides/tests.md



---
Source: ./README.md
---

# Introduction
Tytanic is a test runner for [Typst](https://typst.app/) projects.
It helps you worry less about regressions and speeds up your development.

<a href="https://asciinema.org/a/rW9HGUBbtBnmkSddgbKb7hRlI" target="_blank"><img src="https://asciinema.org/a/rW9HGUBbtBnmkSddgbKb7hRlI.svg" /></a>

## Bird's-Eye View
Out of the box Tytanic supports the following features:
- compile and compare tests
- manage tests of various types
- manage and update reference documents when tests change
- filter tests effectively for concise test runs

## A Closer Look
This book contains a few sections aimed at answering the most common questions right out the gate:
- [Installation](./quickstart/install.md) outlines various ways to install Tytanic.
- [Usage](./quickstart/usage.md) goes over some basic commands to get started.

After the quick start, a few guides delve deeper into some advanced topics, such as
- [Writing Tests](./guides/tests.md) shows how tests work and how you can add, remove, and update them.
- [Using Test Sets](./guides/test-sets.md) delves into the test set language and how it can be used to isolate tests and speed up your TDD workflow.
- [Watching for Changes](./guides/watching.md) explains a workaround for how you can run tests repeatedly on changes to your project files.
- [Setting Up CI](./guides/ci.md) shows how to set up Tytanic in your CI.

The later sections of the book are a technical reference to Tytanic and its various features or concepts:
- [Typst Compatibility](./reference/compat.md) shows which versions of Typst are currently supported and in which version of Tytanic.
- [Tests](./reference/tests/index.md) explains all features of tests in-depth.
- [Test Set Language](./reference/test-sets/index.md) explains the ins and outs of the test set language, listing its operators, built-in bindings and syntactic and semantic intricacies.
- [Configuration Schema](./reference/config.md) lists all existing config options, their expected types and default values.




---
Source: ./reference/compat.md
---

# Typst Compatibility
Tytanic tries to stay close to Typst's release cycle, this means that for each Typst minor version, there should be at least one corresponding minor version of Tytanic.
Release candidates may be exposed via nightly, but not as a corresponding Tytanic release as of yet.

Tytanic will backport patch releases where necessary, but only to the latest corresponding minor version.
Assuming that both Tytanic `v0.15.0` and Tytanic `v0.16.0` target Typst `v0.42.0`, then a new patch version of Typst `v0.42.1` would only be backported as `v0.16.1`, but _not_ to `v0.15.1`.
See the table below for the correspondence of Typst's and Tytanic's versions.

<div class="warning">

If you really need to use Tytanic `v0.15.0` with such a patch of Typst `v0.42.1`, then an installation method like `cargo install` _without_ the `--locked` flag may already be enough.
So, even though these patches may not be explicitly released, they can most often be installed without any issues by compiling from source.

</div>

This one-to-many correspondence doesn't necessarily mean that each Tytanic version can only compile tests for the Typst version it targets, but simply that it makes no guarantees about supporting more than that version.
This is mostly relevant for the stability of its test output, as changes in Typst's default styles and fonts may change the output of a test.

Tytanic was first released when Typst was at version `v0.12.0` and does not provide any versions for Typst `<= v0.11.1`.

<div class="warning">

Note that this may change in the future, if compatibility with multiple versions becomes desirable.
For example, if Typst releases `v1.0`, Tytanic may start to support more than one Typst version per Tytanic version.

</div>

The following table describes all Tytanic and Typst versions and how they correspond to each other.

|Typst|Tytanic|Note|
|---|---|---|
|`<= v0.11.1`|none|unsupported|
|`== v0.12.0`|`v0.1.0 .. v0.1.3`|
|`== v0.13.0-rc1`|`v0.2.0-rc1`|
|`== v0.13.0`|`v0.2.0 .. v0.2.2`|
|`== v0.14.0-rc.1`|`v0.3.0-rc.1`|
|`== v0.14.0-rc.2`|`v0.3.0-rc.2`|
|`== v0.14.0`|`v0.3.0 .. v0.3.1`|
|`== v0.14.1`|`v0.3.2`|
|`== v0.14.2`|`v0.3.3`|
|`>= v0.14.0`|none|unsupported|




---
Source: ./reference/config.md
---

# Config
There are two kinds of configs, system configs and the project config, these have different but overlapping.

## Project Config
The project config is specified in the `typst.toml` manifest under the `tool.tytanic` section.

|Key|Default|Description|
|---|---|---|
|`tests`|`"tests"`|The path in which unit tests are found, relative to the project root.|
|`default.dir`|`ltr`|Sets the default direction used for creating difference documents, expects either `ltr` or `rtl` as an argument. Can be overridden per test using an annotation.|
|`default.ppi`|`144.0`|Sets the default pixel per inch used for exporting and comparing documents, expects a floating point value as an argument. Can be overridden per test using an annotation.|
|`default.max-delta`|`1`|Sets the default maximum allowed per-pixel delta, expects an integer between 0 and 255 as an argument. Can be overridden per test using an annotation.|
|`default.max-deviations`|`0`|Sets the default maximum allowed deviations, expects an integer as an argument. Can be overridden per test using an annotation.|

## System Config
There are currently no system config options and the config is not yet loaded.



---
Source: ./reference/tests/annotations.md
---

# Annotations
Test annotations are used to add information to a test for Tytanic to pick up on.

Annotations may be placed on a leading doc comment block (indicated by `///`), such a doc comment block can be placed after initial empty or regular comment lines, but must come before any content.
All annotations in such a block must be at the start, once non-annotation content is encountered parsing stops.

For ephemeral regression tests only the main test file will be checked for annotations, the reference file will be ignored.

<div class="warning">

The syntax for annotations may change if Typst adds first class annotation or documentation comment syntax.

</div>

```typst
// SPDX-License-Identifier: MIT

/// [skip]
/// [max-delta: 5]
///
/// Synopsis:
/// ...

#import "/src/internal.typ": foo
...
```

The following annotations are available:

|Annotation|Description|
|---|---|
|`skip`|Marks the test as part of the `skip()` test set.|
|`dir`|Sets the direction used for creating difference documents, expects either `ltr` or `rtl` as an argument.|
|`ppi`|Sets the pixel per inch used for exporting and comparing documents, expects a floating point value as an argument.|
|`max-delta`|Sets the maximum allowed per-pixel delta, expects an integer between 0 and 255 as an argument.|
|`max-deviations`|Sets the maximum allowed deviations, expects an integer as an argument.|

## Skip
The skip annotation adds a test to the `skip()` test set, this is a special test set that is automatically wrapped around the `--expression` option `(...) ~ skip()`.
This implicit skip set can be disabled using `--no-skip`.



---
Source: ./reference/test-sets/built-in.md
---

# Built-in Test Sets
## Types
There are a few available types:
|Type|Explanation|
|---|---|
|`function`|Functions which evaluate to another type upon compilation.|
|`test set`|Represents a set of tests.|
|`number`|Positive whole numbers.|
|`string`|Used for patterns containing special characters.|
|`pattern`|Special syntax for test sets which operate on test identifiers.|

A test set expression must always evaluate to a test set, otherwise it is ill-formed, all operators operate on test sets only.
The following may be valid `set(1) & set("aaa", 2)`, but `set() & 1` is not.
There is no arithmetic, and at the time of writing this literals like numbers and strings are included for future test set functionality.

## Functions
The following functions are available, they can be written out in place of any expression.

|Name|Explanation|
|---|---|
|`none()`|Includes no tests.|
|`all()`|Includes all tests.|
|`skip()`|Includes tests with a skip annotation|
|`unit()`|Includes unit tests|
|`template()`|Includes template tests|
|`compile-only()`|Includes tests without references.|
|`ephemeral()`|Includes tests with ephemeral references.|
|`persistent()`|Includes tests with persistent references.|

## Patterns
Patterns are special types which are checked against identifiers and automatically turned into test sets.
A pattern starts with a pattern type before a colon `:` and is either followed by a raw pattern or a string literal.
Raw patterns don't have any delimiters and parse anything that's not whitespace, a literal comma `,` or literal parenthesis `(`/`)`.
String patterns are pattern prefixes directly followed by literal strings, they can be used to clearly denote the start and end of a pattern.
Because parenthesis `(`/`)` are not parsed as raw patterns, regex patterns require quoting if capture groups are used.

The following pattern types exist:

|Type|Example|Explanation|
|---|---|---|
|`e`/`exact`|`exact:mod/name`|Matches by comparing the identifier exactly to the given term.|
|`r`/`regex`|`regex:mod-[234]/.*`|Matches using the given regex.|
|`g`/`glob`|`g:foo/**/bar`|Matches using the given glob pattern.|



---
Source: ./reference/test-sets/eval.md
---

# Evaluation
Test set expressions restrict the set of all tests which are contained in the expression and are compiled to an AST which is checked against all tests sequentially.
A test set such as `!skip()` would be checked against each test that is found by reading its annotations and filtering all tests out which do have an ignored annotation.
While the order of some operations like union and intersection doesn't matter semantically, the left operand is checked first for those where short circuiting can be applied.
As a consequence the expression `!skip() & regex:'complicated regex'` is more efficient than `regex:'complicated regex' & !skip()`, since it will avoid the regex check for skipped tests entirely, but this should not matter in practice.



---
Source: ./reference/test-sets/grammar.md
---

# Grammar
The exact grammar can be read from the source code at [grammar.pest].
Because it is a functional language it consists only of expressions, no statements.

It supports
- groups for precedence (`(...)`),
- binary and unary operators (`and`, `not`, `!`, etc.),
- functions (`func(a, b, c)`),
- patterns (`r:^foo`, `r:"foo,?"`),
- and basic data types like strings (`"..."`, `'...'`) and numbers (`1`, `1_000`).

# Operators
The following operators are available:

|Type|Prec.|Name|Symbols|Explanation|
|---|---|---|---|---|
|infix|1|union|<code>&vert;</code> , `or`|Includes all tests which are in either the left OR right test set expression.|
|infix|1|difference|`~`, `diff`|Includes all tests which are in the left but NOT in the right test set expression.|
|infix|2|intersection|`&`, `and`|Includes all tests which are in both the left AND right test set expression.|
|infix|3|symmetric difference|`^`, `xor`|Includes all tests which are in either the left OR right test set expression, but NOT in both.|
|prefix|4|complement|`!`, `not`|Includes all tests which are NOT in the test set expression.|

Be aware of precedence when combining different operators, higher precedence means operators bind more strongly, e.g. `not a and b` is `(not a) and b`, not `not (a and b)` because `not` has a higher precedence than `and`.
Binary operators are left associative, e.g. `a ~ b ~ c` is `(a ~ b) ~ c`, not `a ~ (b ~ c)`.
When in doubt, use parentheses to force the precedence of expressions.

[grammar.pest]: https://github.com/typst-community/tytanic/blob/main/crates/tytanic-filter/src/ast/grammar.pest



---
Source: ./reference/test-sets/README.md
---

# Test Set Language
The test set language is an expression based language, top level expression can be built up form smaller expressions consisting of binary and unary operators and built-in functions.
They form sets which are used to specify which test should be selected for various operations.

Read the [guide], if you want to see examples of how to use test sets.

## Sections
- [Grammar](./grammar.md) outlines operators and syntax.
- [Evaluation](./eval.md) explains the evaluation of test set expressions.
- [Built-in Test Sets](./built-in.md) lists built-in test sets and functions.

[guide]: ../../guides/test-sets.md



---
Source: ./reference/tests/lib.md
---

# Test Library
The test library is an augmented standard library, it contains all definitions in the standard library plus some additional modules and functions which help testing packages more thoroughly and debug regressions.

It defines the following modules:
- `test`: a module with various testing helpers such as `catch` and additional asserts.

The following items are re-exported in the global scope as well:
- `assert-panic`: originally `test.assert-panic`
- `catch`: originally `test.catch`

## `test`
Contains the main testing utilities.

### `assert-panic`
Ensures that a function panics.

Panics if the function does not panic, returns `none` otherwise.

#### Example
```typst
// panics with the given message
#assert-panic(() => {}, message: "Function did not panic!")

// catches the panic and keeps compilation running
#assert-panic(() => panic())
```

#### Parameters
```txt
assert-panic(
  function,
  message: str | auto,
)
```

> ##### `function: function`
> - `required`
> - `positional`
>
> The function to test.

> ##### `message: str | auto`
>
> The error message when the assertion fails.

### `catch`
Returns the panic message generated by a function, if there was any, returns `none` otherwise.

#### Example
```typst
#assert.eq(catch(() => {}), none)
#assert.eq(
  catch(panics),
  "panicked with: Invalid arg, expected `int`, got `str`",
)
```

#### Parameters
```txt
catch(
  function,
)
```

> ##### `function: function`
> - `required`
> - `positional`
>
> The function to test.



---
Source: ./reference/tests/README.md
---

# Tests
There are three types of tests:
- Unit tests, which are similar to unit or integration tests in other languages and are mostly used to test the API of a package and visual regressions through comparison with reference documents.
  Unit tests are standalone files in a `tests` directory inside the project root and have additional features available inside Typst using a custom standard library.
- Template tests, these are automatically created from a template package's template directory and may not access the augmented standard library.
  Note that there are also unit tests which can access the template directory assets.
  Instead, they receive access to the template assets.
- Doc tests, example code in documentation comments which are compiled but not compared.

<div class="warning">

Tytanic can currently not collect doc tests.

These will be added in the future, see [#34].

</div>

Any unit test may use [annotations](./annotations.md) for configuration.

Read the [guide], if you want to see some examples on how to write and run various tests.

## Sections
- [Unit tests](./unit.md) explains the structure of unit tests.
- [Template tests](./template.md) the usage of template tests.
- [Test library](./lib.md) lists the declarations of the custom standard library.
- [Annotations](./annotations.md) lists the syntax for annotations and which are available.

[guide]: ../../guides/tests.md
[#34]: https://github.com/typst-community/tytanic/issues/34



---
Source: ./reference/tests/template.md
---

# Template Test
Template tests are automatically created for template packages, they receive a special identifier `@template` and cannot be added, updated or removed.
They act like compile-only tests and are part of the `template()` test set.

## Import Translation
The import for the package itself is automatically resolved to the local project directory.
This way, template test can run on unpublished versions without installing the package locally for every change.
At the moment this re-routing of the import is done by comparing the package version and name of the import with that of the current project, assuming the project itself will be published on the `preview` namespace.

Likewise any absolute paths will refer not to the project root, but to the template test path, as this is likely what the user of a template will chose as their root directory after initializing with the template.



---
Source: ./reference/tests/unit.md
---

# Unit tests
Unit tests are those tests found in their own directory identified by a `test.typ` script and are located in `tests`.

Unit tests are the only tests which have access to an extended Typst standard library.
This [test library](./lib.md) contains modules and functions to thoroughly test both the success and failure paths of your project.
Note that tests with a `template` [annotation] cannot use this augmented library, instead they get access to the contents of a package's template directory.

## Test kinds
There are three kinds of unit tests:
- `compile-only`: Tests which are compiled, but not compared to any reference, these don't produce any output.
- `persistent`: Tests which are compared to persistent reference documents.
  The references for these tests are stored in a `ref` directory alongside the test script as individual pages using ONGs.
  These tests can be updated with the `tt update` command.
- `ephemeral`: Tests which are compared to the output of another script.
  The references for these tests are compiled on the fly using a `ref.typ` script.

Each of these kinds is available as a test set function.

## Identifiers
The directory path within the test root `tests` in your project is the identifier of a test and uses forward slashes as path separators on all platforms, the individual components of a test path must satisfy the following rules:
- must start with an ASCII alphabetic character (`a`-`z` or `A`-`Z`)
- may contain any additional sequence of ASCII alphabetic characters, numeric characters (`0`-`9`), underscores `_` or hyphens `-`

## Test structure
Given a directory within `tests`, it is considered a valid test, if it contains at least a `test.typ` file.
The structure of this directory looks as follows:
- `test.typ`: The main test script, this is always compiled as the entry-point.
- `ref.typ` (optional): This makes a test ephemeral and is used to compile the reference document for each invocation.
- `ref` (optional, temporary): This makes a test either persistent or ephemeral and is used to store the reference documents.
  If the test is ephemeral this directory is temporary.
- `out` (temporary): Contains the test output document.
- `diff` (temporary): Contains the difference of the output and reference documents.

The kind of a test is determined as follows:
- If it contains a `ref` directory but no `ref.typ` script, it is considered a persistent test.
- If it contains a `ref.typ` script, it is considered an ephemeral test.
- If it contains neither, it is considered compile only.

Temporary directories are ignored within the VCS if one is detected, this is currently done by simply adding an ignore file within the test directory which ignores all temporary directories.

Unit test are compiled with the project root as their Typst root, such that they can easily access package internals with absolute paths.

<div class="warning">

A test cannot contain other tests, if a test script is found Tytanic will not search for any sub tests, this was previously supported but is being phased out.
Projects which have nested tests will receive a warning and the nested tests will be ignored.
Such projects can migrate by running `tt util migrate`, which will guide the user through and automate such a migration process.

</div>

## Comparison
Ephemeral and persistent tests are currently compared using a simple deviation threshold which determines if two images should be considered the same or different.
If the images have different dimensions consider them different.
Given two images of equal dimensions, pair up each pixel and compare them, if any of the 3 channels (red, green, blue) differ by at least `min-delta` count it as a deviation.
If there are more than `max-deviations` of such deviating pixels, consider the images different.

These values can be tweaked on the command line using the `--max-deviations` and `--min-delta` options respectively:
- `--max-deviations` takes a non-negative integer, i.e. any value from `0` onwards.
- `--min-delta` takes a byte, i.e. any value from `0` to `255`.

Both values default to `0` such that any difference will trigger a failure by default.

[annotation]: ./annotations.md



---
Source: ./SUMMARY.md
---

# Summary
[Introduction](./README.md)

# Quickstart
- [Installation](./quickstart/install.md)
- [Usage](./quickstart/usage.md)

# Guides
- [Writing Tests](./guides/tests.md)
- [Using Test Sets](./guides/test-sets.md)
- [Watching for Changes](./guides/watching.md)
- [Setting Up CI](./guides/ci.md)

# Reference
- [Typst Compatibility](./reference/compat.md)
- [Tests](./reference/tests/README.md)
  - [Unit tests](./reference/tests/unit.md)
  - [Template tests](./reference/tests/template.md)
  - [Documentation tests]()
  - [Annotations](./reference/tests/annotations.md)
  - [Test Library](./reference/tests/lib.md)
- [Test Set Language](./reference/test-sets/README.md)
  - [Grammar](./reference/test-sets/grammar.md)
  - [Evaluation](./reference/test-sets/eval.md)
  - [Built-in Test Sets](./reference/test-sets/built-in.md)
- [Configuration Schema](./reference/config.md)



