# yeet-scripts

`yeet-scripts` is a small command runner/toolbox for project development tasks.
It keeps project-specific commands in `projects/*.env` and reusable tooling in
folder-based modules.

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
howto/                    notes for extending yeet
references/               local reference materials
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
yeet yeet check whitespaces bin lib modules projects howto README.md references/README.md
```

## Extending

Add a new module under `modules/<name>/module.sh` and expose a
`yeet_<name>_main` function. See `howto/02-add-module.md` for a minimal
example.

## License

MIT
