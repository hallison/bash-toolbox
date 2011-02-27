COLUMNS=${COLUMNS:-80}

MESSAGE_INFO="${MESSAGE_INFO:-:: %-$(( COLUMNS - 3))s\n}"
MESSAGE_ERROR="${MESSAGE_ERROR:-!! %-$(( COLUMNS -3 ))s\n}"
MESSAGE_WARN="${MESSAGE_WARN:--- %-$(( COLUMNS -3 ))s\n}"
MESSAGE_STATUS="${MESSAGE_STATUS:-=> %-$(( COLUMNS - 17 ))s [%5s]\\e[6D}"

function message {
  declare format="${MESSAGE_INFO}"
  case ${1} in
    -i|--info  ) format="${MESSAGE_INFO}"   ;;
    -w|--warn  ) format="${MESSAGE_WARN}"   ;;
    -e|--error ) format="${MESSAGE_ERROR}"  ;;
    -s|--status) format="${MESSAGE_STATUS}" ;;
    -*         ) fail "invalid option '${1}'"; return 1 ;;
  esac
  shift

  printf "${format}" "${@}"
}

