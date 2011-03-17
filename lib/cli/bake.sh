
#3 bake(3) -- Bash-Toolbox Make
#3 ============================
#3
#3 ## SYNOPSIS
#3
#3 `#!/usr/bin/env bash-toolbox`
#3
#3 `include ${BASH_TOOLBOX_LIB}/cli`
#3
#3 `source bake.sh`
#3
#3 ## DESCRIPTION
#3
#3 This script should be used as library in source script file or into
#3 Bash sessions. The goal is implements a lightweight interface to create
#3 a task and build manager with syntax suggar.
#3
#3 ## AUTHOR
#3
#3 Written by Hallison Batista &lt;hallison@codigorama.com$gt;
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
#3 [bash-toolbox(1)](bash-toolbox.1.html), [bake(1)](bake.1.html),
#3 [bakefile(5)](bakefile.5.html)
#3

# Timestamp: 2010-01-11 17:40:25 -04:00

# Variables for tasks
declare -a task_names=()
declare -a task_descriptions=()
declare    task_return=0
declare -a task_errors=()
declare -x task_file="${task_file:-[Bb]akefile}"

# Aliases
alias        task='function'
alias    noerrors='test ! "${task_errors[*]}"'
alias   timestamp='command date +%F\ %T.%N\ %z'
alias file_modify='command stat -c %y'
alias file_change='command stat -c %z'

# Add name and description for a task.
function desc {
  declare name="${1:?task name is required}"; shift
  declare desc="${*}"
  declare  new=${#task_descriptions[@]}

  task_names[new]="${name}"
  task_descriptions[new]="${desc}"
}

# Invoke a task
function invoke {
  : ${1:?${FUNCNAME} requires a task name}

  declare task="${1}"
  declare namespace=${task%%:*}

  test "${namespace}" != "${task}" \
    && defined "${namespace}" \
    && "${namespace}"

  "${task}"
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
  : "${1:?${FUNCNAME} requires a task name}"
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
include "${BASH_TOOLBOX_SHARE}/tasks"

# vim: filetype=sh

