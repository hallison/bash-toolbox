source array.sh

array list

if declare list &> /dev/null; then
  echo "array init: ok"
else
  echo "array init: fail"
fi

list[+] "first"
list[+] "second"
list[+] "third"
list[+] "end of array"

if test "$(list[*])" == "first second third end of array"; then
  echo "array itens: ok"
else
  echo "array itens: fail"
fi

if list[?] 4; then
  echo "array check size: ok"
else
  echo "array check size: fail"
fi

list[-] 0

if list[?] 3; then
  echo "array removed: ok"
else
  echo "array removed: fail"
fi

list[~]; do
  if test "${list[i]}" == "$(list[i])"; then
    echo "array loop: '${list[i]}' ok"
  else
    echo "array loop: '${list[i]}' fail"
  fi
done

if test "$(list[:] 0 2)" == "second third"; then
  echo "array subarray: ok ($(list[:] 0 2))"
else
  echo "array subarray: fail"
fi
