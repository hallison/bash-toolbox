
function assert_variable {
  printf "%s: " $"Asserting variable '\${${1}}'"
  declare ${1} &> /dev/null && echo "ok" || echo "fail"
}

function assert_equal {
  printf "%s: " $"Asserting '${1}' equal '${2}'"
  test "${1}" == "${2}" && echo "ok" || echo "fail"
}

function assert {
  printf "%s: " $"Asserting '${*}'"
  if ${@}; then
    echo ok
  else
    echo fail
  fi
  #test ${?} -eq 0 && echo "ok" || echo "fail"
}

function assert_function {
  printf "%s: " $"Asserting function '${1}'"
  command -v ${1} &> /dev/null && echo "ok" || echo "fail"
}

