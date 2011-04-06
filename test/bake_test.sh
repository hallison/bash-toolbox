desc test:hello "Test 'task' alias and show 'Hello world'"
task test:hello {
  echo "Hello world!!!"
}

desc test:status "Test task and status functions"
task test:status {
  start "Running valid commands"
    for i in {0..1}; do
      ls
      sleep 0.${i}
      ls -al
      echo "live and let die ..."
      duck
      git push tilt not
    done
  end

  start "Running invalid commands resulting fail"
    sleep 1
    not-found
    sleep 1
    invalid
    ls not-found
  end
}

desc test:check "Should run other task by result"
task test:check {
  start "Checking 'not-found' directory resulting fail"
    sleep 2
    if ! test -d not-found; then
      ls tests
    fi
  end
}

desc test:all "Run all tests"
task test:all {
  invoke test:hello
  invoke test:status
  invoke test:check
}

default test:all

# vim: filetype=sh

