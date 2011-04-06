= Test task and status functions
  : Running valid commands
    for i in {0..9}; do
      + ls
      + sleep 0.${i}
      + ls -al
    done

  : Running invalid commands resulting fail
    + sleep 1
    + not-found
    + sleep 1
    + invalid

= Should run other task by result
  : Checking 'not-found' directory resulting fail
    + sleep 2
    + ls not-found

# vim: filetype=sh

