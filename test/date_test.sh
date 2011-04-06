#!/usr/bin/env bash-toolbox

set +x

source date.sh
source asserts.sh

date niver=1978-10-08 today=today

assert_variable niver
assert_variable today

for field in ${DATE_FIELDS[@]//%*}; do
  assert_variable niver_${field}
  assert_variable today_${field}
done

assert_equal 1978 ${niver_year}
assert_equal 10 ${niver_month}
assert_equal 08 ${niver_day}

for i in ${!DATE_FIELDS[@]}; do
  format="${DATE_FIELDS[i]//*%/%}"
  field="${DATE_FIELDS[i]//%*}"
  assert_equal $(date_at today ${format}) $(eval "echo \$today_${field}")
done

LANG=pt_BR

niver_printf "Nascido em %d de %B de %Y.\n"

