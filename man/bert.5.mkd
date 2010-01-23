bert(1) -- Bash-Toolbox Command Convert
=======================================

## SYNOPSIS

`bert` [FILE] [CMD_INDEX] ...
`bert` [FILE] [OPTIONS] ...

## DESCRIPTION

`bert` handle command lists defined in a file and run.

## SYNTAX

The `bert` syntax is very simple and easy.

* `=`:

  Define a title.

* `-`:

  Define a subtitle that will be used as status message when list of the
  commands is runned.

* `+`:

  Add a command line that will interpreted by `bert`. That is, the command
  line will be runned in stack of the commands.

Example of the usage a `bert` file contents:

    = Build homepage and documentation

      - Create homepage and documentation directories
        + mkdir -p homepage/doc/api

      - Build API
        + markdown doc/api.mkd -o homepage/doc/api/index.html

      - Build documentation
        + markdown README.mkd -o homepage/index.html
        + markdown doc/faq.mkd -o homepage/doc/faq.html
        + markdown doc/howto.mkd -o homepage/doc/howto.html

## AUTHOR

`bert` was written by Hallison Batista &lt;hallison@codigorama.com&gt;

## COPYRIGHT

Copyright (C) 2009,2010 Codigorama &lt;code@codigorama.com&gt;

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

## SEE ALSO

[bert(1)](bert.1.html), [bert(3)](bert.3.html), [bake(1)](bake.1.html)

