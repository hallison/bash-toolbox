
#3 status(3) -- Bash-Toolbox State of Group Commands
#3 =================================================
#3
#3 ## SYNOPSIS
#3
#3 `\#!/usr/bin/env bash-toolbox`
#3
#3 `source status.sh`
#3
#3 ## DESCRIPTION
#3
#3 This script should be used as library in source script file or into
#3 Bash sessions. The goal is implements the status messages for a group
#3 command.
#3
#3 ## AUTHOR
#3
#3 Written by Hallison Batista &lt;hallison@codigorama.com&gt;
#3
#3 ## COPYRIGHT
#3
#3 Copyright (C) 2009-2011 Codigorama &lt;code@codigorama.com&gt;
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
#3 [bash-toolbox(1)](bash-toolbox.1.html), [messages.sh(3)](messages.1.html)
#3

source messages.sh

function start {
  : ${1:?${FUNCNAME} requires a text message}

  STATUS_BUSY=$"busy"
  STATUS_DONE=$"done"
  STATUS_FAIL=$"fail"
  STATUS_ERROR=$"error"

  declare message="${1}"

  cursor --turn-off

  shift 1

	if test ${#message} -gt ${COLUMNS_STATUS}; then
		message="${message:0:$((COLUMNS_STATUS - 3))}..."
	fi

	message --status "${message}" "${STATUS_BUSY}"

  exec 3>&1
  exec 2>&1
  exec &>>"${STDOUT}"
}

function end {
  declare return=${1:-${?}}
  declare status="${STATUS_DONE}"

  exec 1>&3
  exec 2>&3
  exec 3>&-

  case ${return} in
    0 ) status="${STATUS_DONE}"  ;;
    1 ) status="${STATUS_FAIL}"  ;;
    * ) status="${STATUS_ERROR}" ;;
  esac

  printf "%5s\n" "${status}"

  cursor --turn-on

  return ${return}
}
