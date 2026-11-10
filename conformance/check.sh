#!/usr/bin/env bash
# Checks each conformance example against the standard: the conforming one must
# pass tl check, each broken one must fail for its reason.
set -u
cd "$(dirname "$0")"
fail=0

expect_pass() {  # example
  if out=$(tl -C "$1" check 2>&1); then
    echo "ok    $1 passes"
  else
    echo "FAIL  $1 should pass"; echo "$out"; fail=1
  fi
}

expect_fail() {  # example, text the failure must contain
  if out=$(tl -C "$1" check 2>&1); then
    echo "FAIL  $1 should fail with: $2"; echo "$out"; fail=1
  elif grep -qF -- "$2" <<<"$out"; then
    echo "ok    $1 fails: $2"
  else
    echo "FAIL  $1 failed, but not with: $2"; echo "$out"; fail=1
  fi
}

expect_pass explained
expect_pass shared-glossary
expect_pass full-glossary
expect_fail no-source         "has 0 defined_from link(s) to items outside the graph"
expect_fail own-source        "link defined_from -> TERM-0001 (TERM to TERM) is declared by no link declaration"
expect_fail no-shown          "has 0 shown_by link(s) to items outside the graph"
expect_fail no-example        "example is required always"
expect_fail no-how            "how_it_works is required always"
expect_fail two-glossaries    "register GLS holds 2 live items"
expect_fail gloss-no-audience "has 0 for link(s) to AUD"
expect_fail audience-no-knows "knows is required always"
exit $fail
