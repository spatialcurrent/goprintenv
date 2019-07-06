[![CircleCI](https://circleci.com/gh/spatialcurrent/goprintenv/tree/master.svg?style=svg)](https://circleci.com/gh/spatialcurrent/goprintenv/tree/master) [![Go Report Card](https://goreportcard.com/badge/spatialcurrent/goprintenv)](https://goreportcard.com/report/spatialcurrent/goprintenv)  [![GoDoc](https://godoc.org/github.com/spatialcurrent/goprintenv?status.svg)](https://godoc.org/github.com/spatialcurrent/goprintenv) [![license](http://img.shields.io/badge/license-MIT-red.svg?style=flat)](https://github.com/spatialcurrent/goprintenv/blob/master/LICENSE)

# goprintenv

# Description

**goprintenv** is a super simple command line program for printing environment variables, including in custom formats.  **goprintenv** supports the following operating systems and architectures.  While **goprintenv** does not intend to be a drop-in replacement to the system `printenv` command, it aims to provide a similar command line usage and an enhanced capability.

**Platforms**

| GOOS | GOARCH |
| ---- | ------ |
| darwin | amd64 |
| linux | amd64 |
| windows | amd64 |
| linux | arm64 |

# Installation

No installation is required.  Just grab a [release](https://github.com/spatialcurrent/goprintenv/releases).  You might want to rename your binary to just `goprintenv` (or `printenv`) for convenience.

If you do have go already installed, you can just run using `go run main.go` or install with `make install`

# Usage

See the usage below or the following examples.

```
goprintenv is a super simple utility to print environment variables in a custom format.  Supports: csv, bson, go, json, properties, tags, toml, tsv, yaml.

Usage:
  goprintenv [-f FORMAT] [flags] [variable]...

Flags:
  -f, --format string   output format, one of: csv, bson, go, json, properties, tags, toml, tsv, yaml (default "properties")
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

# Building

You can build all the released artifacts using `make build` or run the make target for a specific operating system and architecture.

# Testing

Run test using `bash scripts/test.sh` or `make test`, which runs unit tests, `go vet`, `go vet with shadow`, [errcheck](https://github.com/kisielk/errcheck), [ineffassign](https://github.com/gordonklaus/ineffassign), [staticcheck](https://staticcheck.io/), and [misspell](https://github.com/client9/misspell).

# Contributing

[Spatial Current, Inc.](https://spatialcurrent.io) is currently accepting pull requests for this repository.  We'd love to have your contributions!  Please see [Contributing.md](https://github.com/spatialcurrent/goprintenv/blob/master/CONTRIBUTING.md) for how to get started.

# License

This work is distributed under the **MIT License**.  See **LICENSE** file.
