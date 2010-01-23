#: base(3) -- bash-toolbox base functions
#: ======================================
#:
#: ## SYNOPSIS
#:
#: \#!/usr/bin/env bash-toolbox
#:
#: ## DESCRIPTION
#:
#: This script should be used as library in source script file or into
#: Bash sessions. The goal is implements the base of Bash-Toolbox projects.
#:
#: ## AUTHOR
#:
#: Written by Hallison Batista &lt;hallison@codigorama.com&gt;
#:
#: ## COPYRIGHT
#:
#: Copyright (C) 2009,2010 Codigorama &lt;code@codigorama.com&gt;
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

# Timestamp: 2010-01-08 17:59:17 -04:00

# Settings
shopt -s expand_aliases
shopt -s shift_verbose
shopt -s xpg_echo
shopt -u restricted_shell
shopt -s sourcepath
#shopt -s globstar

# Aliases
alias   fail='printf "${BASH_SOURCE##*/}: ${FUNCNAME:-main}: %s\n"'
alias  debug='printf "${BASH_SOURCE##*/}: ${FUNCNAME:-main}: line ${LINENO}: %s\n"'
alias caller='nm=$(builtin caller 0); nm=${nm% *}; nm=${nm#* }; echo "${nm}"'

# Read a source file content
function readfile {
  test -r "${1}" && echo "$(1<${1})"
}

# Load a source file content
function load {
  eval "$(readfile ${1})"
}

# Show usage message in header file
function usage {
  content="$(1<${1})"
  content="${content#\#!*#\$}"
  content="${content%\#\$*}"
  content="${content//#\$ }"
  content="${content:1:${#content}}"
  echo "${content//#\$}"
}
alias usage='usage ${BASH_SOURCE}'

# Handle cursor
function cursor {
  case "${1}" in
    #--save     ) printf "\e[s"     ;;
    #--restore  ) printf "\e[r"     ;;
    -e|--turn-on  ) printf "\e[?25h"  ;;
    -d|--turn-off ) printf "\e[?25l"  ;;
    :             ) fail "argument is required";    return 1 ;;
    *             ) fail "invalid argument '${1}'"; return 1 ;;
  esac
  return 0
}

# Incluse a new source path to PATH variable
function include {
  : ${1:?"source path is required"}

  test -d ${1} || fail "enable to include a directory into path"

  PATH="${PATH}:${1}"
}

function trace {
  declare -a sources=(${1})   # BASH_SOURCE
  declare -a functions=(${2}) # FUNCNAME
  declare -a lines=(${3})     # BASH_LINENO

  #for i in ${!BASH_SOURCE[@]}; do
  #  printf "[%03d/%03d] %s: %s@%03d\n" $(( i + 1 )) ${#BASH_SOURCE[@]} \
  #                                      ${BASH_SOURCE[i]##${BASH_TOOLBOX_PATH//..}} \
  #                                      ${FUNCNAME[i]} ${BASH_LINENO[i]}
  #done
  for i in ${!sources[@]}; do
    printf "  [%03d/%03d] %s: %s@%03d\n" $(( i + 1 )) ${#sources[@]} \
                                        ${sources[i]##${BASH_TOOLBOX_PATH//}} \
                                        ${functions[i]} ${lines[i]}
  done
}
alias trace='trace "${BASH_SOURCE[*]}" "${FUNCNAME[*]}" "${BASH_LINENO[*]}"'
# vim: filetype=sh

