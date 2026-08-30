# yeet-scripts

`yeet-scripts` is a small command runner/toolbox for project development tasks.
It keeps project-specific commands in `projects/*.env` and reusable tooling in
folder-based modules.

`yeet` is language-agnostic. It does not care whether a project is written in
C++, Python, JavaScript, Rust, or something else. Project configs decide what
`build`, `run`, `coverage`, or `check` actually execute. The bundled C++
calculator is only a practical demo project.

The intended daily shape is:

```bash
yeet my-app build app
yeet my-app run ut
yeet my-app check cpd
yeet my-app check whitespaces
yeet my-app fix whitespaces
yeet my-app coverage
yeet commit format feat auth add login validation
```

## Requirements

- Bash 4+
- Standard Unix tools: `find`, `grep`, `sed`, `perl`, `mktemp`, `tee`
- Optional: `npx` for the default `jscpd` fallback

On Windows, run `yeet` from Git Bash, WSL, or another Bash-compatible shell.

## Layout

```text
bin/yeet                  main dispatcher
lib/core.sh               shared shell helpers
modules/<name>/module.sh  module entrypoints
projects/<project>.env    project commands and paths
ci/                       CI/CD setup notes
.github/workflows/        GitHub Actions quality workflow
howto/                    notes for extending yeet
examples/                 small projects for manual testing
```

## Installation

Clone the repository and add `bin` to your `PATH`:

```bash
git clone https://github.com/aneq05/yeet-scripts.git
cd yeet-scripts
export PATH="$PWD/bin:$PATH"
```

You can also call the script directly:

```bash
./bin/yeet --help
```

## Quick Start

Create a project config:

```bash
cp projects/example.env projects/my-app.env
```

Edit `YEET_PROJECT_ROOT` and command variables in `projects/my-app.env`.

Then run:

```bash
yeet my-app build app
yeet my-app run ut
```

## Project Config

Each project config is a Bash-compatible `.env` file:

```bash
YEET_PROJECT_ROOT="$HOME/projects/my-app"
YEET_BUILD_APP="cmake --build build"
YEET_RUN_UT="ctest --test-dir build --output-on-failure"
YEET_CPD="npx --yes jscpd ."
YEET_COVERAGE="gcovr --xml coverage.xml --html-details coverage.html"
```

For a Python project, the same command shape could point at Python tooling:

```bash
YEET_PROJECT_ROOT="$HOME/projects/python-app"
YEET_BUILD_APP="python -m compileall src tests"
YEET_RUN_UT="pytest"
YEET_COVERAGE="pytest --cov=src --cov-report=term-missing"
YEET_CPD="npx --yes jscpd src tests"
```

Command variables follow the module naming convention:

```text
YEET_BUILD_<target>
YEET_RUN_<target>
YEET_TEST_<target>
YEET_COVERAGE_<target>
```

Hyphens in command names become underscores, so `build admin-api` reads
`YEET_BUILD_ADMIN_API`.

## Built-In Modules

List available modules:

```bash
yeet modules
```

Run configured build and test commands:

```bash
yeet my-app build app
yeet my-app run ut
```

Run quality checks:

```bash
yeet my-app check cpd
yeet my-app check whitespaces src tests
```

Fix trailing whitespace in text files:

```bash
yeet my-app fix whitespaces src tests
```

Run configured coverage jobs:

```bash
yeet my-app coverage
yeet my-app coverage ut
```

Format commit messages:

```bash
yeet commit format feat auth add login validation
yeet commit format fix cli handle missing project config
```

## Self-Check

This repository includes a `yeet` project config for smoke testing:

```bash
yeet yeet build app
yeet yeet run ut
yeet yeet check whitespaces bin lib modules projects howto README.md
```

## C++ Calculator Demo

The repository includes a tiny C++ calculator project that can be used to test
the tooling end to end after cloning. It uses plain C++ assertions and shell
scripts, so no test framework is required.

```bash
yeet calculator build app
yeet calculator run ut
yeet calculator check cpd
yeet calculator coverage
yeet calculator check whitespaces .
```

The repository includes a GitHub Actions workflow at
.github/workflows/quality.yml. It runs on every push and pull request and
checks whitespace, duplicated code, build status, unit tests, and coverage.
The calculator demo enforces a minimum line coverage of 90%.

The CI setup is language-agnostic: yeet only dispatches configured commands.
For Python, JavaScript, Rust, or another language, add a project config and
point YEET_BUILD_APP, YEET_RUN_UT, YEET_CPD, and YEET_COVERAGE at the
appropriate commands. Coverage thresholds should be enforced by the selected
coverage tool, for example pytest --cov=src --cov-fail-under=90.

See ci/README.md for the CI configuration contract and examples.

The calculator config lives in `projects/calculator.env`, and the demo project
lives in `examples/cpp-calculator`.

To see whitespace detection fail, add trailing spaces to
`examples/cpp-calculator/src/calculator.cpp`, then run the checks from the repository
root. Paths passed to project modules are resolved from `YEET_PROJECT_ROOT`,
so `src` means `examples/cpp-calculator/src` for the `calculator` project.

```bash
yeet calculator check whitespaces src
yeet calculator fix whitespaces src
yeet calculator check whitespaces src
```

Commit message formatting does not require a project:

```bash
yeet commit format feat demo add calculator project smoke test
```

## Extending

Add a new module under `modules/<name>/module.sh` and expose a
`yeet_<name>_main` function. See `howto/02-add-module.md` for a minimal
example.
