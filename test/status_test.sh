source asserts.sh
source status.sh

#shopt -u restricted_shell

stdout="${TMP:-/tmp}/status.log"

rm ${stdout}

message -i "Testing redirections"

status "testing file descriptor redirection" --stdout ${stdout}
  for i in {0..9}; do
    sleep 0.1
    echo ${i}
  done
end

result=($(readfile ${stdout}))

assert_equal "0 1 2 3 4 5 6 7 8 9" "${result[*]}"

status "testing failure"
  echo "failure" > error.log
  false
end

assert_equal 1 ${?}

status "testing error" --stdout ${stdout}
  command-not-exists
end

assert_equal 127 ${?}
