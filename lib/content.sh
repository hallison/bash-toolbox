
#3 content(3) -- Bash-Toolbox Source Content Handler
#3 =================================================
#3
#3 ## SYNOPSIS
#3
#3 `#!/usr/bin/env bash-toolbox`  
#3 `source content.sh`
#3
#3 ## DESCRIPTION
#3
#3 This script should be used as library in source script file or into
#3 Bash sessions. The goal is implements a lightweight interface to handle
#3 script source for help usage messages or documentation.
#3
#3 ## AUTHOR
#3
#3 Written by Hallison Batista &lt;hallison@codigorama.com$gt;
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

## Timestamp: 2010-01-08 17:59:17 -04:00

## Extract documentation from comments in source
function comments {
  test ${#} -eq 0 && fail "argument required" && return 1

  declare char=""

  case ${1} in
    # extract only usage message from the comments started by '$'
    -u|--usage )
      char='$'
    ;;
    # extract only Markdown contents from the comments started by '@'
    -m|--markdown )
      char='@'
    ;;
    # extract only manual contents from the comments started by section
    # numbers between 1 and 8
    -[1-8]|--man[1-8])
      char=${1//--man}
      char=${char//-}
    ;;
    -*)
      fail "argument '${1}' invalid"
      return 1
    ;;
  esac

  shift 1

  declare   origin="$(readfile ${1})"
  declare comments="${origin}"

  if [[ "${comments}" =~ "#${char}" ]]; then
    comments="${comments#\#!*\#${char}}"
    comments="${comments%\#${char}*}"
    comments="${comments//\#${char} }"
    comments="${comments:1:${#comments}}"

    echo "${comments//\#${char}}"
  fi
}

alias    usage='comments --usage ${BASH_SOURCE}'
alias document='comments --markdown ${BASH_SOURCE}'

function meta {
  declare duck="$(comments --usage ${1})"

  comments --tags ${1} | while read line; do
    test "${line}" && duck="${content//@${line%:*}/${line#*: }}"
  done

  echo "$duck"
}
