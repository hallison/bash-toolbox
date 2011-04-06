#!/usr/bin/env bash-toolbox

source date.sh
source asserts.sh

date.new niver=1978-10-08 today=today

assert_variable niver
assert_variable today

assert_equal 1978 $(niver.year)
assert_equal 10 $(niver.month)
assert_equal 08 $(niver.day)

assert_equal $(date +%Y) $(today.year)
assert_equal $(date +%m) $(today.month)
assert_equal $(date +%d) $(today.day)

assert_equal $(date +%F) $(today)

LANG=pt_BR

niver.printf "Nascido em %d de %B de %Y.\n"

