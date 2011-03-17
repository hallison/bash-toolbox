
#3 base(3) -- Bash-Toolbox Base Functions
#3 ======================================
#3
#3 ## SYNOPSIS
#3
#3 \#!/usr/bin/env bash-toolbox
#3
#3 ## DESCRIPTION
#3
#3 This script should be used as library in source script file or into
#3 Bash sessions. The goal is implements the base of Bash-Toolbox projects.
#3
#3 ## AUTHOR
#3
#3 Written by Hallison Batista &lt;hallison@codigorama.com&gt;
#3
#3 ## COPYRIGHT
#3
#3 Copyright (C) 2009,2010 Codigorama &lt;code@codigorama.com&gt;
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
#3 [bash-toolbox(1)](bash-toolbox.1.html)
#3

# Timestamp: 2010-01-08 17:59:17 -04:00

# Settings
shopt -s expand_aliases
shopt -s shift_verbose
shopt -s xpg_echo
shopt -u restricted_shell
shopt -s sourcepath
shopt -s extglob
#shopt -s globstar

# Aliases
alias   fail='printf "${BASH_SOURCE##*/}: ${FUNCNAME:-main}: %s\n"'
alias  debug='printf "${BASH_SOURCE##*/}: ${FUNCNAME:-main}: line ${LINENO}: %s\n"'
alias caller='nm=$(builtin caller 0); nm=${nm% *}; nm=${nm#* }; echo "${nm}"; unset nm'

# Read a source file content
function readfile {
  test -r "${1}" && echo "$(1<${1})"
}

# Load a source file content
function load {
  eval "$(readfile ${1})"
}

# Handle cursor
function cursor {
  case "${1}" in
    -e|--turn-on  ) printf "\e[?25h"  ;;
    -d|--turn-off ) printf "\e[?25l"  ;;
    :             ) fail "argument is required";    return 1 ;;
    *             ) fail "invalid argument '${1}'"; return 1 ;;
  esac
  return 0
}

# Incluse a new source path to PATH variable
function include {
  : ${1:?${FUNCNAME} requires a valid path}

  test -d "${1//\~/${HOME}}" || fail "unable to include '${1}' into path"

  PATH="${PATH//${1}}:${1}"
  PATH="${PATH//::/:}"
}

function trace {
  declare -a sources=(${1})   # BASH_SOURCE
  declare -a functions=(${2}) # FUNCNAME
  declare -a lines=(${3})     # BASH_LINENO

  for i in ${!sources[@]}; do
    printf "  [%03d/%03d] %s: %s@%03d\n" $(( i + 1 )) ${#sources[@]} \
                                        ${sources[i]##${BASH_TOOLBOX_PATH}/} \
                                        ${functions[i]} ${lines[i]}
  done
}
alias trace='trace "${BASH_SOURCE[*]}" "${FUNCNAME[*]}" "${BASH_LINENO[*]}"'

function getvars {
  : ${1:?${FUNCNAME} requires variable names}

  declare -a varnames=()

  while test ${#} -gt 0; do
    if [[ "${1}" == [a-z][A-Z]*=* ]]; then
      declare varname="${1%%=*}"
      if eval "${varname}='${1#*=}'" &> /dev/null ; then
        varnames=("${varnames[@]//${varname}}" "${varname}")
      else
        fail "invalid variable name '${varname}'"
      fi
    fi
    shift 1
  done

  echo "${varnames[@]}"

  return 0
}

function argvar {
  : ${1:?${FUNCNAME} requires argument to declare variable}

  declare varname="${1%%=*}"
          varname="${varname##--}"

  eval "${varname//-/_}=${1##*=}"
}

function getargs {
  : ${1:?${FUNCNAME} requires argument names}

  declare -a argnames=(${1//:/\n})

  shift 1

  while test ${#} -gt 0; do
    for i in ${!argnames[@]}; do
      if [[ "--${argnames[i]}" == "${1}" ]]; then
        eval "${argnames[i]}=\"${1##*=}\""
      fi
    done
  done
}

# vim: filetype=sh

