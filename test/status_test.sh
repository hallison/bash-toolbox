source asserts.sh
source status.sh

#shopt -u restricted_shell

STDOUT="${BASH_TOOLBOX_PATH}/status.tmp"

rm "${STDOUT}"

message -i "Testing redirections"

start "Testing file descriptor redirection"
  for i in {0..9}; do
    sleep 0.1
    echo ${i}
  done
end

result=($(readfile ${STDOUT}))

assert_equal "0 1 2 3 4 5 6 7 8 9" "${result[*]}"

start "Testing failure"
  echo "failure" > error.log
  false
end

assert_equal 1 ${?}

start "Testing error"
  command-not-exists
end

assert_equal 127 ${?}
