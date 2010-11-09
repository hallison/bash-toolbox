source asserts.sh
source messages.sh

shopt -u restricted_shell

output="${TMP}/messages.sh-status.log"

message -i "Testing redirections"
status "testing file descriptor redirection"
  for i in {0..9}; do
    sleep 0.1
    echo ${i}
  done
end

result=($(readfile ${output}))

assert_equal "0 1 2 3 4 5 6 7 8 9" "${result[*]}"

status "testing failure"
  false
end

assert_equal 1 ${?}

status "testing error"
  command-not-exists
end

assert_equal 127 ${?}
