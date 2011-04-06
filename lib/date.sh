# date:year:month:month_name:day:weekday

DATE_FIELDS=(
  year%Y
  month%m
  month_name%B
  day%d
  weekday%A
)

DATE_SKEL="
@date=(\$(date_at @value))

function @date {
  if [[ \${1} != 0 ]]; then
    @date=(\$(date_at \"\${1} \${2}\"))
$(for i in ${!DATE_FIELDS[@]}; do
    echo -n "    "
    echo "@date_${DATE_FIELDS[i]//%*}=\"\${@date[$((i+1))]}\""
  done)
  else
    echo \${@date}
  fi
}

function @date_reload {
  @date \"@value\"
}

function @date_printf {
  printf \"\$(date_at \"\${@date}\" \"\${1}\")\"
}

@date_reload
"

function date_at {
  command date --date "${1}" +"${2:-%F ${DATE_FIELDS[*]//*%/%}}"
}

function date {
  : ${1:?${FUNCNAME} requires a declaration <variable>=<value>}
  : variable: ${input[0]}, value: ${input[1]}
  for attribution in ${@}; do
    declare -a input=(${attribution//=/ })
    declare    skel=""
    skel="${DATE_SKEL//@date/${input[0]}}"
    skel="${skel//@value/${input[1]}}"
    eval "${skel}"
  done
}

## vim: filetype=sh
