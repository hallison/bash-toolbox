
#@ status(3) -- Bash-Toolbox State of Group Sommands
#@ =================================================
#@
#@ ## SYNOPSIS
#@
#@ `\#!/usr/bin/env bash-toolbox`
#@
#@ `source status.sh`
#@
#@ ## DESCRIPTION
#@
#@ This script should be used as library in source script file or into
#@ Bash sessions. The goal is implements the status messages for a group
#@ command.
#@
#@ ## AUTHOR
#@
#@ Written by Hallison Batista &lt;hallison@codigorama.com&gt;
#@
#@ ## COPYRIGHT
#@
#@ Copyright (C) 2009-2011 Codigorama &lt;code@codigorama.com&gt;
#@
#@ Permission is hereby granted, free of charge, to any person obtaining a copy
#@ of this software and associated documentation files (the "Software"), to deal
#@ in the Software without restriction, including without limitation the rights
#@ to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#@ copies of the Software, and to permit persons to whom the Software is
#@ furnished to do so, subject to the following conditions:
#@ 
#@ The above copyright notice and this permission notice shall be included in
#@ all copies or substantial portions of the Software.
#@ 
#@ THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#@ IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#@ FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#@ AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#@ LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#@ OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#@ THE SOFTWARE.
#@
#@ ## SEE ALSO
#@
#@ [bash-toolbox(1)](bash-toolbox.1.html), [messages.sh(3)](messages.1.html)
#@

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
