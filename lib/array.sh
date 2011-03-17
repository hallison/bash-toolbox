
#3 array(3) -- Bash-Toolbox Array
#3 ==============================
#3
#3 ## SYNOPSIS
#3
#3 \#!/usr/bin/env bash-toolbox
#3
#3 source array.sh
#3
#3 ## DESCRIPTION
#3
#3 This script should be used as library in source script file or into
#3 Bash sessions. The goal is implements base functions to handle array
#3 variables in Bash-Toolbox environment.
#3
#3 ## SYNTAX
#3
#3 To declare a new array, just use the following syntax:
#3
#3     array <array-name>
#3
#3 The `array` function will be create dinamically functions that will help
#3 handle the array variable. This functions are:
#3
#3 * `array[*]`:
#3    Returns all itens from array, like `${array[*]}`.
#3
#3 * `array[@]`:
#3    Returns all itens from array, like `${array[@]}`.
#3
#3 * `array[+]`:
#3    Add a new item, like `array=(${array[@]} <new-item>)`.
#3
#3 * `array[-]`:
#3    Remove a item by index, like `array[<index>]=` or
#3    `unset array[<index>]`.
#3
#3 ## AUTHOR
#3
#3 Written by Hallison Batista &lt;hallison@codigorama.com&gt;
#3
#3 ## COPYRIGHT
#3
#3 Copyright (C) 2009,2010 Codigorama &lt;email@codigorama.com&gt;
#3
#3 Permission is hereby granted, free of charge, to any person obtaining a copy
#3 of this software and associated documentation files (the "Software"), to deal
#3 in the Software without restriction, including without limitation the rights
#3 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#3 copies of the Software, and to permit persons to whom the Software is
#3 furnished to do so, subject to the following conditions:
#3
#3 The above copyright notice and this permission notice shall be included in
#3 all copies or substantial portions of the Software.
#3
#3 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#3 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#3 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#3 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#3 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#3 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#3 THE SOFTWARE.
#3
#3 ## SEE ALSO
#3
#3 [bash-toolbox(1)](bash-toolbox.1.html), [base(3)](base.3.html)
#3

# Timestamp: 2010-01-26 00:58:17 -04:00

# Declare a new array with a several functions that improve the syntax.
function array {
  : ${1:?"argument is required"}

  local functions=()

  while getopts ":zqis" option; do
    case ${option} in
      z)  # Function returns array size
          functions=("${functions[@]}" '
            function @array[#] {
              if test ${#} -eq 0; then
                echo "${#@array[@]}"
              else
                test ${#@array[@]} ${@}
              fi
            }'
          ) ;;
      q)  # Function search patterns in itens
          functions=("${functions[@]}" '
            function @array[?] {
              for i in ${!@array[@]}; do
                [[ ${@array[i]} =~ ${1} ]] && echo "${@array[i]}"
              done
            }'
          ) ;;
      i)  # Functions for add and remove items
          functions=("${functions[@]}" '
            function @array[+] {
              while [[ ${#} -gt 0 ]]; do
                @array=(${@array[@]} "${1}")
                shift 1
              done
            }

            function @array[-] {
              unset @array[${1}]
            }'
          ) ;;
      s)  # Function to split a subarray
          functions=("${functions[@]}" '
            function @array[/] {
              echo "${@array[@]:${1}:${2}}"
            }'
          ) ;;
      :)  fail "array name is required"
          return 1 ;;
      ?)  fail "invalid option '${OPTARG}'"
          return 1 ;;
    esac

    shift $((OPTIND - 1))
  done

  while [[ ${#} -gt 0 ]]; do
    # Declare a new array
    eval "${1}=()"

    # Create functions for handle array
    for f in ${!functions[@]}; do
      eval "${functions[f]//@array/${1}}"
    done

    # Function to return array itens
    eval "alias ${1}[*]='echo \"\${${1}[*]}\"'"
    eval "alias ${1}[@]='echo \"\${${1}[@]}\"'"

    # Function returns array index
    eval "alias ${1}[!]='echo \"\${!${1}[@]}\"'"

    # Alias for loop in array index
    eval "alias ${1}[~]='for i in \${!${1}[@]}'"

    # Alias for item in loop array index
    eval "alias ${1}[i]='echo \${${1}[i]}'"

    shift 1
  done

  unset OPTARG OPTIND

  return 0
}

