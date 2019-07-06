# =================================================================
#
# Copyright (C) 2019 Spatial Current, Inc. - All Rights Reserved
# Released as open source under the MIT License.  See LICENSE file.
#
# =================================================================

ifdef GOPATH
GCFLAGS=-trimpath=$(shell printenv GOPATH)/src
else
GCFLAGS=-trimpath=$(shell go env GOPATH)/src
endif

LDFLAGS=-X main.gitBranch=$(shell git branch | grep \* | cut -d ' ' -f2) -X main.gitCommit=$(shell git rev-list -1 HEAD)

.PHONY: help
help:  ## Print the help documentation
	@grep -E '^[a-zA-Z0-9_-\]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

#
# Dependencies
#

.PHONY: deps_go
deps_go:  ## Install Go dependencies
	go get -d -t ./...

.PHONY: deps_go_test
deps_go_test: ## Download Go dependencies for tests
	go get golang.org/x/tools/go/analysis/passes/shadow/cmd/shadow # download shadow
	go install golang.org/x/tools/go/analysis/passes/shadow/cmd/shadow # install shadow
	go get -u github.com/kisielk/errcheck # download and install errcheck
	go get -u github.com/client9/misspell/cmd/misspell # download and install misspell
	go get -u github.com/gordonklaus/ineffassign # download and install ineffassign
	go get -u honnef.co/go/tools/cmd/staticcheck # download and instal staticcheck
	go get -u golang.org/x/tools/cmd/goimports # download and install goimports

.PHONY: deps_arm
deps_arm:  ## Install dependencies to cross-compile to ARM
	# ARMv7
	apt-get install -y libc6-armel-cross libc6-dev-armel-cross binutils-arm-linux-gnueabi libncurses5-dev gcc-arm-linux-gnueabi g++-arm-linux-gnueabi
  # ARMv8
	apt-get install gcc-aarch64-linux-gnu g++-aarch64-linux-gnu


#
# Go building, formatting, testing, and installing
#

.PHONY: fmt
fmt:  ## Format Go source code
	go fmt $$(go list ./... )

.PHONY: imports
imports: ## Update imports in Go source code
	# If missing, install goimports with: go get golang.org/x/tools/cmd/goimports
	goimports -w $$(find . -iname '*.go')

.PHONY: vet
vet: ## Vet Go source code
	go vet $$(go list ./...)

.PHONY: test_go
test_go: ## Run Go tests
	bash scripts/test.sh

.PHONY: build
build: build_cli  ## Build all artifacts

.PHONY: install
install:  ## Install goprintenv on current platform
	go install -gcflags="$(GCFLAGS)" -ldflags="$(LDFLAGS)" github.com/spatialcurrent/goprintenv

#
# Command Line Programs
#

bin/goprintenv_darwin_amd64: ## Build goprintenv for Darwin / amd64
	GOOS=darwin GOARCH=amd64 go build -o bin/goprintenv_darwin_amd64 -gcflags="$(GCFLAGS)" -ldflags="$(LDFLAGS)" $$(go list ./...)

bin/goprintenv_linux_amd64: ## Build goprintenv for Linux / amd64
	GOOS=linux GOARCH=amd64 go build -o bin/goprintenv_linux_amd64 -gcflags="$(GCFLAGS)" -ldflags="$(LDFLAGS)" $$(go list ./...)

bin/goprintenv_windows_amd64.exe:  ## Build goprintenv for Windows / amd64
	GOOS=windows GOARCH=amd64 go build -o bin/goprintenv_windows_amd64.exe -gcflags="$(GCFLAGS)" -ldflags="$(LDFLAGS)" $$(go list ./...)

bin/goprintenv_linux_arm64:  ## Build goprintenv for Linux / arm64
	GOOS=linux GOARCH=arm64 go build -o bin/goprintenv_linux_arm64 -gcflags="$(GCFLAGS)" -ldflags="$(LDFLAGS)" $$(go list ./...)

bin/goprintenv_linux_arm: ## Build goprintenv for Linux / arm
	GOOS=linux GOARCH=arm go build -o bin/goprintenv_linux_arm -gcflags="$(GCFLAGS)" -ldflags="$(LDFLAGS)" $$(go list ./...)

.PHONY: build_cli
build_cli: bin/goprintenv_darwin_amd64 bin/goprintenv_linux_amd64 bin/goprintenv_windows_amd64.exe bin/goprintenv_linux_arm bin/goprintenv_linux_arm64 ## Build command line programs

## Clean

.PHONY: clean
clean:  ## Clean artifacts
	rm -fr bin
	rm -fr dist
