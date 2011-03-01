COLUMNS=${COLUMNS:-80}

COLUMNS_INFO=$((COLUMNS - 3))
COLUMNS_ERROR=$((COLUMNS - 3))
COLUMNS_WARN=$((COLUMNS - 3))
COLUMNS_STATUS=$((COLUMNS - 17))

MESSAGE_INFO="${MESSAGE_INFO:-:: %-${COLUMNS_INFO}s\n}"
MESSAGE_ERROR="${MESSAGE_ERROR:-!! %-${COLUMNS_ERROR}s\n}"
MESSAGE_WARN="${MESSAGE_WARN:--- %-${COLUMNS_WARN}s\n}"
MESSAGE_STATUS="${MESSAGE_STATUS:-=> %-${COLUMNS_STATUS}s [%5s]\\e[6D}"

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

