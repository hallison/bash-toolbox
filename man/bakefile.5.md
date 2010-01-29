Bakefile(7) -- Bash-Toolbox Make file
=====================================

## DESCRIPTION

The `Bakefile` is a set of tasks that will be load and invoke by `bake`
command.

## TASKS

### DESCRIBED TASKS

Task is a function that is inside the stack tasks. The tasks that will be used
in command line must be describe using the function `desc`

You define a new task using the following methods:

* Describe a new task with name and description using the command `desc`. The
  `desc` command will push the information to the stack of tasks. Then it
  necessary write the defined task..
* Define the new task using the command `task` like a function.

Example:

    desc <task-name> <task-description>  
    task <task-name> {  
      # ... task-body  
    }  

You can sign all the tasks and their descriptions and then write them.

    # Description block
    desc <task1> <description1>
    desc <task2> <description2>
    desc <task3> <description3>
    desc <task4> <description4>

`  `

    task <task1> {
      # ... task1
    }

    task <task2> {
      # ... task2
    }

    task <task3> {
      # ... task3
    }

    task <task4> {
      # ... task4
    }

### ANONYMOUS TASKS

When you do not describe a task, then, it is anonymous and your scope is
only internal, that is, it can not invoked by `bake` externally. This is
useful when you want write a task only invoked by others tasks. Example:

    desc install "Install the application"
    task install {
      build # invoking build task
      # ... install
    }

    # anonymous build
    task build {
      # ... build
    }

### NAMESPACED TASKS

You can define a task with namespace.

    desc tar:gz "Create/update tarball package and compress using gzip"
    task tar:gz {
      # ... create tar.gz
    }

In this case, when a namespaced task is invoked, first check if namespace is
defined as task inside the stack. If defined, then will be invoked first.
Otherwise, the task is executed.

    desc tar "Create/update tarball package"
    task tar {
      # ... create tar file or define variables
    }

    desc tar:gz "Compress tarball using gzip"
    task tar:gz {
      # ... create tar.gz
    }

    desc tar:bz2 "Compress tarball using bzip2"
    task tar:bz2 {
      # ... create tar.bz2
    }

Before invoke "tar:gz" or "tar:bz2" the namespace task "tar" will be invoked
first.

## AUTHOR

`bake` was written by Hallison Batista &lt;hallison@codigorama.com&gt;

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

[bake(1)](bake.1.html), [bake(3)](bake.3.html), [bert(1)](bert.1.html)

