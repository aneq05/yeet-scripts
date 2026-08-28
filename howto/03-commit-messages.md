# Commit Messages

`yeet commit format` produces Conventional Commit-style messages.

```bash
yeet commit format feat auth add login validation
```

prints:

```text
feat(auth): add login validation
```

Supported types:

```text
feat fix docs style refactor test chore ci build perf revert
```

If the first word is not a known type, `yeet` treats the whole input as a
`chore` message:

```bash
yeet commit format clean generated coverage artifacts
```

prints:

```text
chore: clean generated coverage artifacts
```
