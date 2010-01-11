# Extracn only Markdown contents from comments started by '#:'
function srcdoc {
  content="$(1<${1})"
  content="${content#\#!*#:}"
  content="${content%\#:*}"
  content="${content//#: }"
  content="${content:1:${#content}}"
  echo "${content//#:}"
}

