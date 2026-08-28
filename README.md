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

## Layout

```text
bin/yeet                  main dispatcher
lib/core.sh               shared shell helpers
modules/<name>/module.sh  module entrypoints
projects/<project>.env    project commands and paths
howto/                    notes for extending yeet
references/               source photos and visual references
```

## Quick Start

1. Add `bin` to your `PATH`, or call the script directly:

   ```bash
   ./bin/yeet --help
   ```

2. Create a project config:

   ```bash
   cp projects/example.env projects/my-app.env
   ```

3. Edit `YEET_PROJECT_ROOT` and command variables in `projects/my-app.env`.

4. Run:

   ```bash
   ./bin/yeet my-app build app
   ./bin/yeet my-app run ut
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
