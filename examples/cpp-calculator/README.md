# C++ Calculator Demo

This is a tiny dependency-free C++ project used to test `yeet-scripts` in a
real project layout.

It has:

- application sources in `src/`
- a public header in `include/`
- unit tests in `tests/`
- project-local commands in `scripts/`
- a `yeet` project config in `../../projects/calculator.env`

From the repository root:

```bash
yeet calculator build app
yeet calculator run ut
yeet calculator check cpd
yeet calculator coverage
yeet calculator check whitespaces .
```
