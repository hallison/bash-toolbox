#: btodo(3) -- bash-toolbox todo runner
#: ====================================
#:
#: ## SYNOPSIS
#:
#: `#!/usr/bin/env bash-toolbox`
#: `source btodo.sh`
#:
#: ## DESCRIPTION
#:
#: This script is a library and must be used in source script file. The goal
#: is implements a lightweight interface to create a todo list of commands and
#: manager.
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
#: ## SEE ALSO
#:
#: `btodo(1)`, `btake(1)`

# Variables for stacks
declare -a todo_titles=()
declare    todo_return=0
declare -a todo_errors=()
declare -x todo_file="${todo_file:-[Tt]odofile}"

# Formats
#declare  TODO_COMMAND="${TODO_COMMAND:-'* %-74s [busy]\\e[5D\\n'}"
#declare  TODO_COMMAND="${TODO_COMMAND:-\e[G* %-72s [%03d/%03d]}"
declare  TODO_COMMAND="${TODO_COMMAND:-  > %-66s [%5s]\e[6D}"
declare  TODO_STATUS="${TODO_STATUS:-* %-76s\n}"

# Aliases
alias no-errors='test ! "${todo_errors[*]}"'

function = {
  test "${*}" && {
    declare new=${#todo_titles[@]}

    todo_titles[new]="${@}"

    eval "todo_${new}=()"
  } || {
    fail $"todo title is required"
    exit 1
  }
}

# Add commands in current todo item.
function + {
  test "${todo_titles[*]}" && {
    declare current=$(( ${#todo_titles[@]} - 1 ))

    eval "todo_${current}[\${#todo_${current}[@]}]='${*}'"
  } || {
    fail $"todo list not defined"
    exit 1
  }
}

#   no-errors && {
#     printf "%4s\n" $"done"
#     return 0
#   } || {
#     printf "%4s\n" $"fail"
#     return ${todo_return}
#   }'

function @ {
  + "dump \"${1}\""
}

# Display a status message
function : {
  + "status:${*}"
}

# Run commands redirecting output to null
function pop {
  test ${#} -gt 0 && {
    declare new=${#todo_errors[@]}
    eval "${@# } &> /dev/null"
    todo_return=${?}
    test ${todo_return} -gt 0 && todo_errors[new]=${todo_return}
    return ${todo_return}
  } || {
    return 0
  }
}

# Dump item from current todo
function dump {
  test ${#} -gt 0 && {
    declare todo="todo_${1:-0}"
    declare status="busy"
    declare index

    eval "index=\${!${todo}[@]}"

    cursor --turn-off

    for i in ${index}; do
      eval "command=\${${todo}[${i}]}"
      eval "n=\${#${todo}[@]}"
      test "${command%%:*}" == "status" && {
        printf "${TODO_STATUS}" "${command:7:76}"
      } || {
        status="busy"
        printf "${TODO_COMMAND}" "${command:0:66}" "${status}"
        pop ${command}
        test ${todo_return} -gt 0 && status="error" || status="done"
        printf "%5s\n" "${status}"
      }
      #printf "  \e[?25l[%03d/%03d] %-70s\e[G" "$(( i + 1 ))" "${n}" "${command:0:72}"
    done
    cursor --turn-on
    return 0
  }
}

function defined {
  test ${1} -lt ${#todo_titles[@]} && return 0 || return 1
}

# vim: filetype=sh

