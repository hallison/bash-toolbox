desc test:hello "Test 'task' alias and show 'Hello world'"
task test:hello {
  echo "Hello world!!!"
}

desc test:status "Test task and status functions"
task test:status {
  status "Running valid commands"
  for i in {0..1}; do
    run ls
    run sleep 0.${i}
    run ls -al
    run echo "live and let die ..."
    run duck
    run git push tilt not
  done

  status "Running invalid commands resulting fail"
  run sleep 1
  run not-found
  run sleep 1
  run invalid
  run ls not-found
}

desc test:check "Should run other task by result"
task test:check {
  status "Checking 'not-found' directory resulting fail"
  run sleep 2
  if ! test -d not-found; then
    run ls tests
  fi
}

#desc test-file "Test file operations"
#task test-file {
#  file not-found
#  file README.mkd && {
#    run markdown README.mkd -o README.html
#  }
#}

desc test:all "Run all tests"
task test:all {
  test:hello
  test:status
  test:check
}

default test:all

# vim: filetype=sh

