#!/bin/bash

alias bigfiles="find . -type f -size +1000k -exec ls -lk {} \; | awk '{print \$5, \$9}' | sort -nr +1 | head"
alias bigdirs="du -sk * | sort -nr | head"
alias vim="lvim"

# Misc aliases

# Git aliases
alias br='git branch'
alias nbr='git checkout -b'
alias dbr='git branch | grep -v "main" | xargs git branch -D'
alias ci='git commit -av'
alias co='git checkout'
alias lg='git log -p'
alias pull='git pull origin `git rev-parse --abbrev-ref HEAD`'
alias push='git push origin `git rev-parse --abbrev-ref HEAD`'
alias sha='git rev-parse HEAD'
alias st='git status'

# Ask for confirmation before overwriting or deleting files.
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

# For a nicely formatted dump of LD_LIBRARY_PATH ...
alias eld="echo LD_LIBRARY_PATH :; echo -n '   ';echo \$LD_LIBRARY_PATH |sed 's/:/\n   /g'"

# Code printing (fancy two columns)
alias ens="enscript --borders --columns=2 --fancy-header --landscape --line-numbers=1 --mark-wrapped-lines=arrow --pretty-print=cpp"
alias ens1="enscript --borders --fancy-header --line-numbers=1 --mark-wrapped-lines=arrow --pretty-print=cpp -L63"

alias findcss="find3 css"
alias findhtml="find3 html"
alias findhtml1="find-depth-1 html"
alias findjs="find3 js"
alias findts="find3 ts"
alias findjs2="find4 js"
alias findjson="find3 json"
alias findless="find3 less"

# Goes to root directory of current git repo.
alias cdgitroot='cd `git rev-parse --git-dir`; cd ..'

# Display directories and executables in different colors.
#alias ls='ls --color=tty'
alias ls='ls -G'
alias ll='ls -lh -a'

# For a nicely formatted dump of any path delimited with colons ...
# To use this enter "echo $PATH | nicepath".
alias nicepath="tr ':' '\n'"

# This is just like nicepath, but used when the path is delimited with spaces.
alias nicepathspaces="sed 's/ /\n   /g'"

# Kill the process listening on a given port.
alias klp="kill-listening-process"

