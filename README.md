[![CircleCI](https://circleci.com/gh/spatialcurrent/goprintenv/tree/master.svg?style=svg)](https://circleci.com/gh/spatialcurrent/goprintenv/tree/master) [![Go Report Card](https://goreportcard.com/badge/spatialcurrent/goprintenv)](https://goreportcard.com/report/spatialcurrent/goprintenv)  [![GoDoc](https://godoc.org/github.com/spatialcurrent/goprintenv?status.svg)](https://godoc.org/github.com/spatialcurrent/goprintenv) [![license](http://img.shields.io/badge/license-MIT-red.svg?style=flat)](https://github.com/spatialcurrent/goprintenv/blob/master/LICENSE)

# goprintenv

## Description

**goprintenv** is a super simple command line program for printing environment variables, including in custom formats.  **goprintenv** supports the following operating systems and architectures.  While **goprintenv** does not intend to be a drop-in replacement to the system `printenv` command, it aims to provide a similar command line usage and an enhanced capability.

## Platforms

The following platforms are supported.  Pull requests to support other platforms are welcome!

| GOOS | GOARCH |
| ---- | ------ |
| darwin | amd64 |
| linux | amd64 |
| windows | amd64 |
| linux | arm64 |

## Releases

Find releases at [https://github.com/spatialcurrent/goprintenv/releases](https://github.com/spatialcurrent/goprintenv/releases).  You might want to rename your binary to just `goprintenv` (or `printenv`) for convenience.  See the **Building** section below to build from scratch.

**Darwin**

- `goprintenv_darwin_amd64` - CLI for Darwin on amd64 (includes `macOS` and `iOS` platforms)

**Linux**

- `goprintenv_linux_amd64` - CLI for Linux on amd64
- `goprintenv_linux_amd64` - CLI for Linux on arm64

**Windows**

- `goprintenv_windows_amd64.exe` - CLI for Windows on amd64

## Usage

See the usage below or the following examples.

```shell
goprintenv is a super simple utility to print environment variables in a custom format.
Supports the following formats: csv, bson, go, gob, json, properties, tags, toml, tsv, yaml.

Usage:
  goprintenv [-f FORMAT] [flags] [variable]...

Flags:
  -f, --format string   output format, one of: csv, bson, go, gob, json, properties, tags, toml, tsv, yaml (default "properties")
  -h, --help            help for goprintenv
  -0, --null            use a NUL byte to end each line instead of a newline character
  -p, --pretty          use pretty output format
  -r, --reversed        if output is sorted, sort in reverse alphabetical order
  -s, --sorted          sort output
```

# Examples

**All Environment Variables**

```shell
goprintenv -f json
```

**Subset of Environment Variables**

`goprintenv` accepts a list of environment variables.

```shell
goprintenv SHELL PATH
```

**Subset of Environment Variables as Pretty JSON**

`goprintenv` accepts a list of environment variables and a custom format.

```shell
goprintenv -f json -p SHELL PATH
```

## Building

Use `make help` to see help information for each target.

**CLI**

The `make build_cli` script is used to build executables for Linux and Windows.  Use `make install` for standard installation as a go executable.

**Changing Destination**

The default destination for build artifacts is `bin`, but you can change the destination with an environment variable.  For building on a Chromebook consider saving the artifacts in `/usr/local/go/bin`, e.g., `DEST=/usr/local/go/bin make build_cli`

## Testing

**CLI**

To run CLI testes use `make test_cli`, which uses [shUnit2](https://github.com/kward/shunit2).  If you recive a `shunit2:FATAL Please declare TMPDIR with path on partition with exec permission.` error, you can modify the `TMPDIR` environment variable in line or with `export TMPDIR=<YOUR TEMP DIRECTORY HERE>`. For example:

```
TMPDIR="/usr/local/tmp" make test_cli
```

**Go**

To run Go tests use `make test_go` (or `bash scripts/test.sh`), which runs unit tests, `go vet`, `go vet with shadow`, [errcheck](https://github.com/kisielk/errcheck), [ineffassign](https://github.com/gordonklaus/ineffassign), [staticcheck](https://staticcheck.io/), and [misspell](https://github.com/client9/misspell).

## Contributing

[Spatial Current, Inc.](https://spatialcurrent.io) is currently accepting pull requests for this repository.  We'd love to have your contributions!  Please see [Contributing.md](https://github.com/spatialcurrent/goprintenv/blob/master/CONTRIBUTING.md) for how to get started.

## License

This work is distributed under the **MIT License**.  See **LICENSE** file.
