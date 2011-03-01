
#: bake(3) -- Bash-Toolbox Make
#: ============================
#:
#: ## SYNOPSIS
#:
#: `#!/usr/bin/env bash-toolbox`
#:
#: `include ${BASH_TOOLBOX_CLI}`
#:
#: `source bake.sh`
#:
#: ## DESCRIPTION
#:
#: This script should be used as library in source script file or into
#: Bash sessions. The goal is implements a lightweight interface to create
#: a task and build manager with syntax suggar.
#:
#: ## AUTHOR
#:
#: Written by Hallison Batista &lt;hallison@codigorama.com$gt;
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
#: [bash-toolbox(1)](bash-toolbox.1.html), [bake(1)](bake.1.html),
#: [bakefile(5)](bakefile.5.html)
#:

# Timestamp: 2010-01-11 17:40:25 -04:00

# Global constants
declare TMP=${TMP:-/tmp}
#declare SRC=${BASH_SOURCE##*/}
#declare LIB=${BASH_SOURCE%/*}/

# Variables for tasks
declare -a task_names=()
declare -a task_descriptions=()
declare    task_return=0
declare -a task_errors=()
declare -x task_file="${task_file:-[Bb]akefile}"

# Formats
#declare  TASK_COMMAND="${TASK_COMMAND:-'* %-74s [busy]\\e[5D\\n'}"
#declare  TASK_COMMAND="${TASK_COMMAND:-\e[G* %-72s [%03d/%03d]}"
declare  TASK_COMMAND="${TASK_COMMAND:-  > %-66s [%5s]\e[6D}"
declare  TASK_STATUS="${TASK_STATUS:-* %s\n}"
declare  TASK_ERROR="${TASK_ERROR:-    %02d: %s: %d : %s\n}"
declare  TASK_ERROR_FILE=${TMP}/${BASH_SOURCE##*/}.errors

# Aliases
alias     task='function'
alias noerrors='test ! "${task_errors[*]}"'
alias timestamp='command date +%F\ %T.%N\ %z'
alias file_modify='command stat -c %y'
alias file_changy='command stat -c %z'

# Add name and description for a task.
function desc {
  declare name="${1:?task name is required}"; shift
  declare desc="${*}"
  declare  new=${#task_descriptions[@]}

  task_names[new]="${name}"
  task_descriptions[new]="${desc}"

  #eval "task_${name//-/_}=()"
}

#   noerrors && {
#     printf "%4s\n" $"done"
#     return 0
#   } || {
#     printf "%4s\n" $"fail"
#     return ${task_return}
#   }'

# TODO: remove this?
function errors {
  : "${1:?error index is required}"
  if test -f ${TASK_ERROR_FILE}.${1}; then
    local error="$(readfile ${TASK_ERROR_FILE}.${1})"
    printf "${TASK_ERROR}" ${1} ${task_errors[1]} "${error##*:}"
  fi
}

# Invoke a task
function invoke {
  : ${1:?"task name is required"}

  declare task="${1}"
  declare namespace=${task%%:*}

  rm ${TASK_ERROR_FILE}* &> /dev/null

  test "${namespace}" != "${task}" && ${namespace}
  ${task} #|| errors ${task_return}
}

# Check if a task was defined
function defined {
  for i in ${!task_names[@]}; do
    test "${task_names[i]}" == "${1}" && return 0
  done
  return 1
}

# Define a task as default
function default {
  : "${1:?task name is required}"
  defined "${1}" && {
    task_default="${1}"
    return 0
  }
}

# TOFIX: this function not works
function file {
  : ${1:?"file name is required"}
  : ${2:?"dependency file name is required"}
  declare file="${1}"; shift
  declare changes=()
  for dependency in ${[@]}; do
    # check out of date
    test "$(timestamp ${file})" > "$(timestamp ${dependency})"
  done
}

# Use a shared task set
include ${BASH_TOOLBOX_SHARE:-share/bash-toolbox}/tasks

# vim: filetype=sh

