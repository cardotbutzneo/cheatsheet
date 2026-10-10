## Overview ##

Bash (Bourne Again SHell) is the default shell on most Linux distributions. It is both a command-line interpreter and a scripting language.
It is not a "real" programming language like Python or C: it is mostly used to chain commands together, automate tasks, and write small scripts (installation, backups, build, etc.).
Everything is text: variables are strings, and programs communicate through text streams.

Run a script:
~~~bash
#!/usr/bin/env bash
# the first line is the shebang: it tells the system which interpreter to use
echo "Hello world"
~~~

~~~bash
chmod +x script.sh     # make it executable
./script.sh            # run it
bash script.sh         # or run it explicitly with bash
~~~

A good habit at the top of a script:
~~~bash
set -euo pipefail
~~~
- `-e`: stop at the first command that fails
- `-u`: error when using an undefined variable
- `-o pipefail`: a pipeline fails if any command in it fails

---

### Variables

**No spaces around `=`**. This is the most common mistake.

~~~bash
name="Bob"          # OK
name = "Bob"        # ERROR: bash thinks "name" is a command

echo $name          # Bob
echo "${name}"      # same, braces are useful: "${name}_file"
~~~

Use a `$` to **read** a variable, not to assign it.
Always put quotes around variable expansions (`"$name"`), otherwise a value with spaces is split into several words.

**Quotes**
~~~bash
a="world"
echo "hello $a"     # hello world (variables are expanded)
echo 'hello $a'     # hello $a    (literal, nothing is expanded)
~~~

**Command substitution and arithmetic**
~~~bash
today=$(date +%F)       # store the output of a command
echo "Today: $today"

n=$((3 + 4 * 2))        # integer arithmetic only
echo $((n % 3))
((n++))                 # increment
~~~

Bash only handles **integers**. For floats, use `bc` or `awk`:
~~~bash
echo "scale=2; 10 / 3" | bc      # 3.33
~~~

**Environment variables**
~~~bash
export PATH="$HOME/bin:$PATH"    # export: visible by child processes
echo "$HOME" "$USER" "$PWD"
~~~

**Special variables**

- `$0`: name of the script
- `$1`, `$2`, ...: arguments of the script (or function)
- `$#`: number of arguments
- `$@`: all arguments (use `"$@"` with quotes)
- `$?`: exit status of the last command (`0` = success, anything else = error)
- `$$`: PID of the current shell

**Default values and string operations**
~~~bash
echo "${var:-default}"      # "default" if var is unset or empty
file="archive.tar.gz"
echo "${#file}"             # 14 (length)
echo "${file%.gz}"          # archive.tar (remove suffix)
echo "${file#archive.}"     # tar.gz (remove prefix)
echo "${file/tar/zip}"      # archive.zip.gz (replace the first match)
echo "${file:0:7}"          # archive (substring)
~~~

**Read user input**
~~~bash
read -r -p "Your name? " name
echo "Hi $name"
~~~

---

### If / else, tests & comparisons

~~~bash
age=20
if [[ $age -le 12 ]]; then
    echo "You're a kid"
elif [[ $age -gt 12 && $age -lt 18 ]]; then
    echo "You're a teenager"
else
    echo "You're an adult"
fi
~~~

Spaces are mandatory inside `[[ ... ]]`. Prefer `[[ ]]` over the older `[ ]` (safer, more features, but specific to bash).

**Numbers** use letters, not symbols:
- `-eq` equal, `-ne` not equal
- `-lt` less than, `-le` less or equal
- `-gt` greater than, `-ge` greater or equal

(Inside `(( ... ))` you can use the usual `<`, `>`, `==`: `if (( age < 18 )); then`.)

**Strings**
- `==` equal, `!=` different
- `-z "$s"` empty string, `-n "$s"` non-empty
- `=~` regex match: `[[ $s =~ ^[0-9]+$ ]]`

**Files**
- `-e` exists, `-f` regular file, `-d` directory
- `-r` readable, `-w` writable, `-x` executable
- `-s` exists and is not empty

~~~bash
if [[ -f "config.txt" ]]; then
    echo "found"
fi
~~~

**Logical operators**
- `&&` AND, `||` OR, `!` NOT

They also chain commands: `cmd1 && cmd2` runs `cmd2` only if `cmd1` succeeded, `cmd1 || cmd2` only if it failed.
~~~bash
mkdir build && cd build
grep -q "error" log.txt || echo "no error found"
~~~

An `if` actually tests the **exit status of a command**: `0` is true, anything else is false (the opposite of C!).
~~~bash
if grep -q "root" /etc/passwd; then
    echo "root exists"
fi
~~~

**case**
~~~bash
case "$1" in
    start)   echo "Starting" ;;
    stop)    echo "Stopping" ;;
    *)       echo "Usage: $0 {start|stop}" ;;
esac
~~~

---

### Loops

~~~bash
# for over a list
for fruit in apple banana cherry; do
    echo "$fruit"
done

# for over files (use globs, NOT $(ls))
for f in *.txt; do
    echo "$f"
done

# for over a range
for i in {1..5}; do
    echo "$i"
done

# C-style for
for ((i = 0; i < 5; i++)); do
    echo "$i"
done

# while
n=0
while [[ $n -lt 3 ]]; do
    echo "$n"
    ((n++))
done

# read a file line by line
while IFS= read -r line; do
    echo "$line"
done < file.txt
~~~

`break` and `continue` work as in C.

---

### Arrays

~~~bash
arr=(10 20 30)
echo "${arr[0]}"          # 10
echo "${arr[-1]}"         # 30 (last element)
echo "${arr[@]}"          # all elements
echo "${#arr[@]}"         # 3 (length)
arr+=(40)                 # append

for x in "${arr[@]}"; do
    echo "$x"
done
~~~

**Associative arrays** (dictionaries, bash 4+)
~~~bash
declare -A ages
ages[Bob]=25
ages[Alice]=31

echo "${ages[Bob]}"       # 25
echo "${!ages[@]}"        # all the keys
echo "${ages[@]}"         # all the values
~~~

---

### Functions

~~~bash
greet() {
    local name="$1"            # local: the variable stays inside the function
    echo "Hello $name"
}

greet "Alice"                  # no parentheses when calling
~~~

- Arguments are `$1`, `$2`, ..., `$#`, `"$@"`, as for a script.
- Variables are **global by default**: use `local`.
- `return` only gives an **exit status** (an integer from 0 to 255), not a value.
- To "return" a value, print it and capture it with `$(...)`.

~~~bash
max() {
    if (( $1 > $2 )); then
        echo "$1"
    else
        echo "$2"
    fi
}

result=$(max 3 7)
echo "$result"                 # 7

is_even() {
    (( $1 % 2 == 0 ))          # the exit status is the result
}

if is_even 4; then
    echo "even"
fi
~~~

---

### Redirections & pipes

Every program has three streams: `stdin` (0), `stdout` (1) and `stderr` (2).

- `cmd > file`: write stdout to a file (overwrite)
- `cmd >> file`: append stdout to a file
- `cmd < file`: read stdin from a file
- `cmd 2> err.txt`: redirect stderr
- `cmd > out.txt 2>&1` (or `cmd &> out.txt`): stdout and stderr in the same file
- `cmd > /dev/null`: throw the output away
- `cmd1 | cmd2`: the stdout of `cmd1` becomes the stdin of `cmd2` (pipe)

~~~bash
ls -l | grep ".txt" | wc -l            # count the .txt files
cat access.log | sort | uniq -c | sort -nr | head -5
~~~

Other useful tools:
~~~bash
cmd | tee out.txt         # display AND save the output
diff <(sort a.txt) <(sort b.txt)       # process substitution
cat << EOF                # here-document
Hello $USER
EOF
~~~

---

### Essential commands

**Navigation and files**
~~~bash
pwd                       # current directory
ls -la                    # list all files, with details
cd dir                    # change directory (cd .. up, cd - previous, cd alone = home)
mkdir -p a/b/c            # create directories (and parents)
cp -r src dst             # copy (-r for directories)
mv old new                # move or rename
rm file                   # delete (no trash!)
rm -r dir                 # delete a directory recursively
touch file                # create an empty file / update its date
~~~

**Be careful with `rm -rf`: there is no undo.** Always check the path (and the variable inside it) before running it.

**Reading files**
~~~bash
cat file                  # print the whole file
less file                 # scroll (q to quit)
head -n 5 file            # first 5 lines
tail -n 5 file            # last 5 lines
tail -f log.txt           # follow a file in real time
wc -l file                # number of lines
~~~

**Searching and text processing**
~~~bash
grep "text" file          # lines containing "text"
grep -rn "text" dir       # recursive, with line numbers
grep -i / -v / -c         # ignore case / invert / count
find . -name "*.py"       # find files by name
find . -type f -mtime -1  # files modified in the last day
sort file                 # sort lines (-n numeric, -r reverse)
uniq -c                   # count adjacent duplicates (sort first!)
cut -d',' -f1,3 file.csv  # columns 1 and 3 of a CSV
tr 'a-z' 'A-Z'            # replace characters
sed 's/old/new/g' file    # replace text
awk '{print $1}' file     # print the first column
xargs                     # build commands from stdin: find . -name "*.o" | xargs rm
~~~

**Permissions**
~~~bash
chmod +x script.sh        # add the execute permission
chmod 644 file            # rw-r--r--
chown user:group file     # change the owner
~~~

Digits: read = 4, write = 2, execute = 1, in the order owner / group / others (`755` = `rwxr-xr-x`).

**Processes and system**
~~~bash
ps aux                    # list the processes
top / htop                # live monitoring
kill PID                  # ask a process to stop (kill -9 PID to force it)
cmd &                     # run in the background
jobs / fg / bg            # manage background jobs
Ctrl+C / Ctrl+Z           # stop / suspend the current command
df -h / du -sh dir        # disk space
man cmd / cmd --help      # documentation
which cmd                 # where a command is located
~~~

**Aliases and history**
~~~bash
alias ll='ls -la'         # put it in ~/.bashrc to make it permanent
history                   # list of previous commands
!!                        # repeat the last command
Ctrl+R                    # search in the history
~~~

---

### Common pitfalls

- `a = 1` (with spaces) does not work, write `a=1`.
- Forget the quotes: `rm $file` breaks if the name contains a space. Write `rm "$file"`.
- Do not parse `ls` (`for f in $(ls)`): use `for f in *`.
- `[ ]`/`[[ ]]` need spaces inside the brackets.
- Use `-eq`, `-lt`... for numbers and `==` for strings (`[[ 10 == 10.0 ]]` is false because they are strings).
- An exit status of `0` means success (true), the opposite of C.
- Variables are global by default: use `local` in functions.
- Bash is not great for complex logic: if a script gets long, switch to Python.

---

### Complete example

~~~bash
#!/usr/bin/env bash
set -euo pipefail

# Usage: ./backup.sh <directory>
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <directory>" >&2
    exit 1
fi

src="$1"
if [[ ! -d "$src" ]]; then
    echo "Error: $src is not a directory" >&2
    exit 1
fi

backup="backup_$(date +%F).tar.gz"
tar -czf "$backup" "$src"
echo "Created $backup ($(du -h "$backup" | cut -f1))"
~~~