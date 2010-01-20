#: btdoc(3) -- bash-toolbox documentation extractor
#: ================================================
#:
#: ## SYNOPSIS
#:
#: `#!/usr/bin/env bash-toolbox`
#: `source btdoc.sh`
#:
#: ## DESCRIPTION
#:
#: This script should be used as library in source script file or into
#: Bash sessions. The goal is implements a lightweight interface to create
#: a stack manager.
#:
#: ## AUTHOR
#:
#: Written by Hallison Batista &lt;hallison@codigorama.com$gt;
#:
#: Timestamp
#: : 2010-01-08 17:59:17 -04:00
#:
#: ## COPYRIGHT
#:
#: Copyright (C) 2009-2010 Codigorama &lt;code@codigorama.com&gt;
#:

# Extract only Markdown contents from the comments started by '#:'
function srcdoc {
  content="$(1<${1})"
  content="${content#\#!*#:}"
  content="${content%\#:*}"
  content="${content//#: }"
  content="${content:1:${#content}}"
  echo "${content//#:}"
}

