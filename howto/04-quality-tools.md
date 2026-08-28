# Quality Tools

The first included quality checks are intentionally small wrappers:

```bash
yeet my-app check cpd
yeet my-app check whitespaces
yeet my-app fix whitespaces
yeet my-app coverage
```

`check cpd` runs `YEET_CPD` from the project config. If it is not configured,
it falls back to:

```bash
npx --yes jscpd .
```

`check whitespaces` scans text files for trailing spaces and tabs.

`fix whitespaces` removes trailing spaces and tabs from files under the chosen
paths, skipping common generated folders.

`coverage` runs `YEET_COVERAGE` or `YEET_COVERAGE_<target>`.
