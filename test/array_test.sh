source array.sh
source asserts.sh

array -siqz list

array -i options

assert_variable list
assert_variable options
assert_function list[*]
assert_function list[@] # function to show all itens
assert_function list[#] # function to handle array size
assert_function list[!] # function to show array index
assert_function list[?] # function to search itens that match with a pattern
assert_function list[+] # function to add
assert_function list[-] # function to remove
assert_function list[/] # function to split a subarray

list[+] "first"
list[+] "second"
list[+] "third" "end of array"

options[+] "h" "e" "l" "p"

assert_equal "$(list[*])" "first second third end of array"
assert_equal "$(options[*])" "h e l p"

assert list[#] -eq 4

list[-] 0

assert list[#] -eq 3

list[~]; do
  assert_equal "${list[i]}" "$(list[i])"
done

assert_equal "$(list[/] 0 2)" "second third"

assert_equal "second" "$(list[?] 'sec*')"

match_list=($(list[?] 'sec*|thir*'))

assert_equal 2 ${#match_list[@]}
assert_equal "second third" "${match_list[*]}"
