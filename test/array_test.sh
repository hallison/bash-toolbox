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

list[:]; do
  echo "array loop: ${list[i]} ok"
  list[i]
done

