#: bash-make(3) -- bash-toolbox make
#: =================================
#:
#: ## SYNOPSIS
#:
#: `#!/usr/bin/env bash-toolbox`
#: `source btake.sh`
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
#: Timestamp
#: : 2010-01-11 17:40:25 -04:00
#:
#: ## COPYRIGHT
#:
#: Copyright (C) 2009-2010 Codigorama &lt;code@codigorama.com&gt;
#:

declare TMP=${TMP:-/tmp}

# Variables for tasks
declare -a task_names=()
declare -a task_descriptions=()
declare    task_return=0
declare -a task_errors=()
declare -x task_file="${task_file:-[Tt]askfile}"

# Formats
#declare  TASK_COMMAND="${TASK_COMMAND:-'* %-74s [busy]\\e[5D\\n'}"
#declare  TASK_COMMAND="${TASK_COMMAND:-\e[G* %-72s [%03d/%03d]}"
declare  TASK_COMMAND="${TASK_COMMAND:-  > %-66s [%5s]\e[6D}"
declare  TASK_STATUS="${TASK_STATUS:-* %s\n}"
declare  TASK_ERROR="${TASK_ERROR:-    %02d: %-8s: %03d : %-44s\n}"
declare  TASK_ERRORS_PATH=${TMP}/${BASH_SOURCE##*/}.errors

# Aliases
alias      task='function'
alias no-errors='test ! "${task_errors[*]}"'

# Add name and description for a task.
function desc {
  declare name="${1:?task name is required}"
  declare desc="${2:-${1}}"
  declare  new=${#task_descriptions[@]}

  task_names[new]="${name}"
  task_descriptions[new]="${desc}"

  #eval "task_${name//-/_}=()"
}

#   no-errors && {
#     printf "%4s\n" $"done"
#     return 0
#   } || {
#     printf "%4s\n" $"fail"
#     return ${task_return}
#   }'

# Display a status message
function status {
  printf "${TASK_STATUS}" "${1}"
}

# Run commands redirecting output to null
function run {
  test ${#} -gt 0 && {
    declare    new=${#task_errors[@]}
    declare    format="%5s\n"
    declare    status="busy"
    declare -a command=()

    for arg in "${@}"; do
      cmd=${#command[@]}
      [[ ${arg} =~ ' ' ]] && command[cmd]="'${arg}'" || command[cmd]="${arg}"
    done

    cursor --turn-off

    printf "${TASK_COMMAND}" "${command[*]:0:66}" "${status}"

    "${command[@]}" &> ${TASK_ERRORS_PATH}.${new}

    task_return=${?}

    test ${task_return} -eq 0 && {
      status="done"
      printf "${format}" "${status}"
    } || {
      local error="$(1<${TASK_ERRORS_PATH}.${new})"
      status="error"
      printf "${format}" "${status}"
      task_errors[new]="${command[0]} ${task_return}"
      printf "${TASK_ERROR}" ${new} ${task_errors[new]} "${error##*:}"
    }
    #printf "${TASK_COMMAND}\n" "${*}" "${status}"
    cursor --turn-on
  }
  return ${task_return}
}

function errors {
  local error=${1}
  error="$(1<${TASK_ERRORS_PATH}.${i})"
  printf "${TASK_ERROR}" ${i} ${task_errors[i]} "${error##*:}"
}

# Invoke a task
function invoke {
  declare task="${1:?task name is required}"
  declare namespace=${task%%:*}
  test "${namespace}" != "${task}" && ${namespace}
  ${task}
  errors
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
  defined "${1:?task name is required}" && {
    task_default="${1}"
    return 0
  }
}

function file {
  declare file="${1:?file name is required}"
  #declare file_options=$(echo {a..h} L k p r s S t u w x O G N)
  declare file_options="e f g r s w"

  status $"Checking file '${file}'"
  for check in ${file_options}; do
    run "test -${check} ${file}"
  done
}

# vim: filetype=sh

