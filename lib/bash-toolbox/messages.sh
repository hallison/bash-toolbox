COLUMNS=${COLUMNS:-80}

MESSAGE_INFO="${MESSAGE_INFO:-:: %-$(( COLUMNS - 3))s\n}"
MESSAGE_ERROR="${MSG_ERROR:-!! %-$(( COLUMNS -3 ))s\n}"
MESSAGE_WARN="${MSG_WARN:--- %-$(( COLUMNS -3 ))s\n}"
MESSAGE_STATUS="${MSG_STATUS:-=> %-$(( COLUMNS - 17 ))s [%5s]\\e[6D}"

STATUS_BUSY=$"busy"
STATUS_DONE=$"done"
STATUS_FAIL=$"fail"
STATUS_ERROR=$"error"

function message {
  declare formmat="${MESSAGE_INFO}"
  case ${1} in
    -i|--info  ) format="${MESSAGE_INFO}"  ;;
    -w|--warn  ) format="${MESSAGE_WARN}"  ;;
    -e|--error ) format="${MESSAGE_ERROR}" ;;
    -*         ) fail "invalid option '${1}'"; return 1 ;;
  esac
  shift

  printf "${formmat}" "${*}"
}

function status {
  printf "${MESSAGE_STATUS}" "${*}" "${STATUS_BUSY}"
  exec 3>&1
  exec 2>&1
  exec &> ${BASH_TOOLBOX_LOG}
}

function end {
  declare return=${1:-${?}}
  declare status="${STATUS_DONE}"

  exec 1>&3 3>&-

  case ${return} in
    0 ) status="${STATUS_DONE}"  ;;
    1 ) status="${STATUS_FAIL}"  ;;
    * ) status="${STATUS_ERROR}" ;;
  esac

  printf "%5s\n" "${status}"

  return ${return}
}
