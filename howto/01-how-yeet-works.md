# How yeet Works

`yeet` is a dispatcher. It decides whether the first argument is a module or a
project name, loads the project config when needed, then forwards the remaining
arguments to a module.

```text
yeet <project> <module> <command> [args...]
yeet <module> <command> [args...]
```

Examples:

```bash
yeet my-app build app
yeet my-app run ut
yeet my-app check cpd
yeet commit format fix cli reject unknown module
```

The project form loads `projects/<project>.env`.

The module form is useful for global commands, for example commit message
formatting.

## Module Contract

Every module lives in:

```text
modules/<module>/module.sh
```

and exposes:

```bash
yeet_<module>_main() {
  # parse args and call helpers from lib/core.sh
}
```

For module names with hyphens, the entrypoint uses underscores.
