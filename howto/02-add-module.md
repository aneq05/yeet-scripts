# Add a Module

Create a folder:

```text
modules/hello/module.sh
```

Add an entrypoint:

```bash
#!/usr/bin/env bash

yeet_hello_main() {
  local command="${1:-}"
  shift || true

  case "$command" in
    greet)
      printf 'Hello, %s!\n' "${1:-world}"
      ;;
    *)
      yeet_die "Usage: yeet hello greet <name>"
      ;;
  esac
}
```

Then run:

```bash
yeet hello greet Ala
```

Checklist:

- The module name does not collide with an existing module.
- The folder name matches the CLI command.
- The entrypoint is named `yeet_<module>_main`.
- Unknown commands return a non-zero status through `yeet_die`.
- Help text shows a runnable example.
