# ORDER TESTS

Simple script to put **@Order** numbers for **@Test** in a Java / Kotlin file.

## Command usage

```shell
order-tests [] [--dry-run] [--debug] <path_0> [path_1] ... [path_x]
```

| Parameter          | Abbr | Required | Default Value | Description                    |
|:-------------------|:----:|:--------:|:--------------|:-------------------------------|
| `--[no-]recursive` |      |    No    | Enabled       | Search recursively.            |
| `--dry-run`        | `-d` |    No    | Disabled      | To do a dry run.               |
| `--debug`          | `-v` |    No    | Disabled      | Show debug messages.           |
| `path`             |      |   Yes    |               | Directory to search for tests. |

### Administration options

| Parameter              | Abbr | Required | Default Value | Description        |
|:-----------------------|:----:|:--------:|:--------------|:-------------------|
| `--[no-]check-updates` |      |    No    | Enabled       | Check for updates. |
| `--version`            | `-V` |    No    |               | Show version.      |
| `--help`               | `-h` |    No    |               | Show help.         |
