source array.sh
source asserts.sh

array list

assert_variable list
assert_function list[*]
assert_function list[@] # function to show all itens
assert_function list[#] # function to handle array size
assert_function list[!] # function to show array index
assert_function list[+] # function to add
assert_function list[-] # function to remove
assert_function list[:] # function to split a subarray

list[+] "first"
list[+] "second"
list[+] "third"
list[+] "end of array"

assert_equal "$(list[*])" "first second third end of array"

assert list[#] -eq 4

list[-] 0

assert list[#] -eq 3

list[~]; do
  assert_equal "${list[i]}" "$(list[i])"
done

assert_equal "$(list[:] 0 2)" "second third"

