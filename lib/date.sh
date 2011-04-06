# date:year:month:month_name:day:weekday

declare -a DATE_FIELDS=(
  date%F
  year%Y
  month%m
  month.name%B
  day%d
  weekday%A
)

declare -a DATE_SKEL="
  function @date {
    if [[ \${1} -ne 0 ]]; then
      @date=(date.at \"\${1} \${2:-days}\")
    fi
    echo \${@date[0]}
  }
  function @date.reload { @date=(date.at \"@value\"); }
  function @date.printf {
    local format="\${1}"; shift
    printf \"\$(date --date \${@date[0]} +\"\${format}\")\"
  }

"

function date.at {
  date --date "${1}" +"${DATE_FIELDS[*]//*%/%}"
}

function date.new {
  : ${1:?${FUNCNAME} requires a declaration <variable>=<value>}
  : variable: ${input[0]}, value: ${input[1]}
  while [[ ${#} -gt 0 ]]; do
    declare -a input=(${1//=/ })
    declare    skel=""
    eval "${input[0]}=($(date.at ${input[1]}))"
    skel="${DATE_SKEL//@date/${input[0]}}"
    skel="${skel//@value/${input[1]}}"
    eval "${skel}"
    for i in ${!DATE_FIELDS[@]}; do
      : skel: @date.${DATE_FIELDS[i]//%*}
      skel="
        function ${input[0]}.${DATE_FIELDS[i]//%*} {
          echo \${${input[0]}[$i]};
        }"
      echo "${skel}" >> out.tmp
      eval "${skel}"
    done
    shift 1
  done
}


## vim: filetype=sh
