
#: content(3) -- Bash-Toolbox Source Content Handler
#: =================================================
#:
#: ## SYNOPSIS
#:
#: `#!/usr/bin/env bash-toolbox`  
#: `source content.sh`
#:
#: ## DESCRIPTION
#:
#: This script should be used as library in source script file or into
#: Bash sessions. The goal is implements a lightweight interface to handle
#: script source for help usage messages or documentation.
#:
#: ## AUTHOR
#:
#: Written by Hallison Batista &lt;hallison@codigorama.com$gt;
#:
#: ## COPYRIGHT
#:
#: Copyright (C) 2009,2010 Codigorama &lt;code@codigorama.com&gt;
#:
#: Permission is hereby granted, free of charge, to any person obtaining a copy
#: of this software and associated documentation files (the "Software"), to deal
#: in the Software without restriction, including without limitation the rights
#: to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#: copies of the Software, and to permit persons to whom the Software is
#: furnished to do so, subject to the following conditions:
#: 
#: The above copyright notice and this permission notice shall be included in
#: all copies or substantial portions of the Software.
#: 
#: THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#: IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#: FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#: AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#: LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#: OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#: THE SOFTWARE.
#:

## Timestamp: 2010-01-08 17:59:17 -04:00

## Extract documentation from comments in source
function comments {
  test ${#} -eq 0 && fail "argument required" && return 1

  declare char=""

  case ${1} in
    # extract only usage message from the comments started by '$'
    -u|--usage    ) char='$' ;;
    # extract only Markdown contents from the comments started by ':'
    -m|--markdown ) char=':' ;;
    #-t|--tags     ) char='@' ;;
    -*            ) fail "argument '${1}' invalid" && return 1 ;;
  esac
  shift

  declare   origin="$(readfile ${1})"
  declare comments="${origin}"

  comments="${comments#\#!*\#${char}}"
  comments="${comments%\#${char}*}"
  comments="${comments//\#${char} }"
  comments="${comments:1:${#comments}}"

  test "${comments//${char}}" != "${origin}" && echo "${comments//\#${char}}"
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
