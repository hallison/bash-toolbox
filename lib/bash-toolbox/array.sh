
#: array(3) -- Bash-Toolbox Array
#: ==============================
#:
#: ## SYNOPSIS
#:
#: \#!/usr/bin/env bash-toolbox
#:
#: source array.sh
#:
#: ## DESCRIPTION
#:
#: This script should be used as library in source script file or into
#: Bash sessions. The goal is implements base functions to handle array
#: variables in Bash-Toolbox environment.
#:
#: ## SYNTAX
#:
#: To declare a new array, just use the following syntax:
#:
#:     array <array-name>
#:
#: The `array` function will be create dinamically functions that will help
#: handle the array variable. This functions are:
#:
#: * `array[*]`:
#:    Returns all itens from array, like `${array[*]}`.
#:
#: * `array[@]`:
#:    Returns all itens from array, like `${array[@]}`.
#:
#: * `array[+]`:
#:    Add a new item, like `array=(${array[@]} <new-item>)`.
#:
#: * `array[-]`:
#:    Remove a item by index, like `array[<index>]=` or
#:    `unset array[<index>]`.
#:
#: ## AUTHOR
#:
#: Written by Hallison Batista &lt;hallison@codigorama.com&gt;
#:
#: ## COPYRIGHT
#:
#: Copyright (C) 2009,2010 Codigorama &lt;email@codigorama.com&gt;
#:
#: Permission is hereby granted, free of charge, to any person obtaining a copy
#: of this software and associated documentation files (the "Software"), to deal
#: in the Software without restriction, including without limitation the rights
#: to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#: copies of the Software, and to permit persons to whom the Software is
#: furnished to do so, subject to the following conditions:
#: 
#: The above copyright notice and this permission notice shall be included in
#: all copies or substantial portions of the Software.
#: 
#: THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#: IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#: FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#: AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#: LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#: OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#: THE SOFTWARE.
#:
#: ## SEE ALSO
#:
#: [bash-toolbox(1)](bash-toolbox.1.html)
#:

# Timestamp: 2010-01-26 00:58:17 -04:00

# Declare a new array with a several functions that improve ths syntax.
function array {
  : ${1:?"array name is required"}
  # Declare a new array
  eval "${1}=()"
  # Function to return array itens
  eval "function ${1}[*] { echo \"\${${1}[*]}\";  }"
  eval "function ${1}[@] { echo \"\${${1}[@]}\";  }"

  # Function returns array size
  eval "function ${1}[#] { echo \"\${#${1}[@]}\"; }"

  # Function returns array index
  eval "function ${1}[!] { echo \"\${!${1}[@]}\"; }"

  # Function test array size
  eval "function ${1}[?] { test \${#${1}[@]} -eq \${1}; }"

  # Function add a new item into array
  eval "function ${1}[+] { ${1}=(\${${1}[@]} \"\${1}\"); }"

  # Function remove a item by index
  eval "function ${1}[-] { unset ${1}[\${1}]; }"

  # Alias for loop in array index
  eval "alias ${1}[:]='for i in \${!${1}[@]}'"

  # Alias for item in loop array index
  eval "alias ${1}[i]='echo \${${1}[i]}'"
}

