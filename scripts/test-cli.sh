#!/bin/bash

# =================================================================
#
# Copyright (C) 2019 Spatial Current, Inc. - All Rights Reserved
# Released as open source under the MIT License.  See LICENSE file.
#
# =================================================================

set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

testDefault() {
  local input="hello world"
  local expected='hello world'
  local output=$(GOPRINTENV_TEST=${input} goprintenv | grep "GOPRINTENV_TEST" | cut -d= -f2)
  assertEquals "unexpected output" "${expected}" "${output}"
}

testTagsOne() {
  local output=$(A="hello world" goprintenv -f tags A)
  assertEquals "unexpected output" 'A="hello world"' "${output}"
}

testTagsTwo() {
  local output=$(A="hello" B="world" goprintenv -f tags A B)
  assertEquals "unexpected output" 'A=hello B=world' "${output}"
}

testTagsSorted() {
  local output=$(A="hello" B="world" goprintenv -f tags -s B A)
  assertEquals "unexpected output" 'A=hello B=world' "${output}"
}

testTagsReversed() {
  local output=$(A="hello" B="world" goprintenv -f tags -s -r A B)
  assertEquals "unexpected output" 'B=world A=hello' "${output}"
}

oneTimeSetUp() {
  echo "Using temporary directory at ${SHUNIT_TMPDIR}"
}

oneTimeTearDown() {
  echo "Tearing Down"
}

# Load shUnit2.
. "${DIR}/shunit2"