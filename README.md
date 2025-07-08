# ORDER TESTS

Simple app to put **@Order** numbers for tests in a Java or Kotlin file.

## Install script

https://github.com/edufolly/order_tests/refs/heads/main/scripts/linux_x86_64.sh

## Direct installation for Linux x86

```shell
curl -fsSL https://raw.githubusercontent.com/edufolly/order_tests/refs/heads/main/scripts/linux_x86_64.sh | sudo bash
```

For Windows and Mac, please visit the release page:
https://github.com/edufolly/order_tests/releases/latest

## Command usage

```shell
order-tests [--dry-run] [--debug] <path_0> [path_1] ... [path_x]
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
