# ORDER TESTS

Simple app to put **@Order** numbers for **@Test** in a Java / Kotlin file.

## Install script

https://gist.github.com/edufolly/b994536b9183428c20d41dca68925e80

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
