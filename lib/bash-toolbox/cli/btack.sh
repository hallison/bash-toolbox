#: btack(3) -- bash-toolbox stack commands
#: =======================================
#:
#: ## SYNOPSIS
#:
#: `#!/usr/bin/env bash-toolbox`
#: `source btack.sh`
#:
#: ## DESCRIPTION
#:
#: This script should be used as library in source script file or into
#: Bash sessions. The goal is implements a lightweight interface to create
#: a stack manager.
#:
#: ## AUTHOR
#:
#: Written by Hallison Batista &lt;hallison@codigorama.com$gt;
#:
#: Timestamp
#: : 2010-01-08 17:59:17 -04:00
#:
#: ## COPYRIGHT
#:
#: Copyright (C) 2009-2010 Codigorama &lt;code@codigorama.com&gt;
#:

# Variables for stacks
declare -a stack_descriptions=()
declare    stack_return=0
declare -a stack_errors=()
declare -x stack_file="${stack_file:-[Ss]tackfile}"

# Formats
#declare  STACK_COMMAND="${STACK_COMMAND:-'* %-74s [busy]\\e[5D\\n'}"
#declare  STACK_COMMAND="${STACK_COMMAND:-\e[G* %-72s [%03d/%03d]}"
declare  STACK_COMMAND="${STACK_COMMAND:-  > %-66s [%5s]\e[6D}"
declare  STACK_STATUS="${STACK_STATUS:-* %-76s\n}"

# Aliases
alias no-errors='test ! "${stack_errors[*]}"'

function = {
  test "${*}" && {
    declare new=${#stack_descriptions[@]}

    stack_descriptions[new]="${@}"

    eval "stack_${new}=()"
  } || {
    fail $"stack description is required"
    exit 1
  }
}

# Push commands in current stack stack.
function + {
  test "${stack_descriptions[*]}" && {
    declare current=$(( ${#stack_descriptions[@]} - 1 ))

    eval "stack_${current}[\${#stack_${current}[@]}]='${*}'"
  } || {
    fail $"no stacks defined"
    exit 1
  }
}

#   no-errors && {
#     printf "%4s\n" $"done"
#     return 0
#   } || {
#     printf "%4s\n" $"fail"
#     return ${stack_return}
#   }'

function @ {
  + "dump \"${1}\""
}

# Display a status message
function : {
  + "stack_status:${*}"
}

# Run commands redirecting output to null
function pop {
  test ${#} -gt 0 && {
    declare new=${#stack_errors[@]}
    eval "${@# } &> /dev/null"
    stack_return=${?}
    test ${stack_return} -gt 0 && stack_errors[new]=${stack_return}
    return ${stack_return}
  } || {
    return 0
  }
}

# Dump item from current stack
function dump {
  test ${#} -gt 0 && {
    declare stack="stack_${1:-0}"
    declare status="busy"
    declare index

    eval "index=\${!${stack}[@]}"

    cursor --turn-off

    for i in ${index}; do
      eval "command=\${${stack}[${i}]}"
      eval "n=\${#${stack}[@]}"
      test "${command%%:*}" == "stack_status" && {
        printf "${STACK_STATUS}" "${command:13:76}"
      } || {
        status="busy"
        printf "${STACK_COMMAND}" "${command:0:66}" "${status}"
        pop ${command}
        test ${stack_return} -gt 0 && status="error" || status="done"
        printf "%5s\n" "${status}"
      }
      #printf "  \e[?25l[%03d/%03d] %-70s\e[G" "$(( i + 1 ))" "${n}" "${command:0:72}"
    done
    cursor --turn-on
    return 0
  }
}

function defined {
  test ${1} -lt ${#stack_descriptions[@]} && return 0 || return 1
}

# vim: filetype=sh

