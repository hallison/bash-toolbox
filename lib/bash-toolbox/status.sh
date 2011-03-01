source messages.sh

function status {
  STATUS_BUSY=$"busy"
  STATUS_DONE=$"done"
  STATUS_FAIL=$"fail"
  STATUS_ERROR=$"error"

  : ${1:?${FUNCNAME} requires a text message}

  declare message="${1}"
  declare  stdout="${BASH_TOOLBOX_LOG:-/tmp/bash-toolbox.log}"

  cursor --turn-off

  shift 1

  while [[ ${#} -gt 0 ]]; do
    case "${1}" in
      -o|--stdout ) stdout="${2}" ;;
      -*          ) fail $"invalid option '${1}'"; return 1 ;;
    esac
    shift 1
  done

	if test ${#message} -gt ${COLUMNS_STATUS}; then
		message="${message:0:$((COLUMNS_STATUS - 3))}..."
	fi

	message --status "${message}" "${STATUS_BUSY}"

  exec 3>&1
  exec 2>&1
  exec &>>"${stdout}"
}

function end {
  declare return=${1:-${?}}
  declare status="${STATUS_DONE}"

  exec 1>&3 2>&3 3>&-

  case ${return} in
    0 ) status="${STATUS_DONE}"  ;;
    1 ) status="${STATUS_FAIL}"  ;;
    * ) status="${STATUS_ERROR}" ;;
  esac

  printf "%5s\n" "${status}"

  cursor --turn-on

  return ${return}
}
