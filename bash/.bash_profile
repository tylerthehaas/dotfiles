#!b/in/bash
echo running .bash_profile

unset COLUMNS # to prevent ps from truncating lines
set noclobber

# Files to ignore in filename completion.
export FIGNORE='.o:.swp'

# Look for libraries in standard places.
export LD_LIBRARY_PATH=.:$HOME/lib:/usr/local/lib:/usr/lib:$LD_LIBRARY_PATH

#-------------------------------------------------------------------------

export PATH="/Users/tyler.haas/.local/bin:$PATH"

# Commonly used directory prefixes.

export PROGRAMMING_DIR=$HOME/programming
export DATABASES_DIR=$PROGRAMMING_DIR/databases
export LANGUAGES_DIR=$PROGRAMMING_DIR/languages
export CSS_DIR=$LANGUAGES_DIR/CSS
export HTML_DIR=$LANGUAGES_DIR/html
export JAVA_DIR=$LANGUAGES_DIR/java
export JAVASCRIPT_DIR=$LANGUAGES_DIR/javascript
export JQUERY_DIR=$JAVASCRIPT_DIR/jquery
export TOOLS_DIR=$HOME/tools

# asdf settings
. $(brew --prefix asdf)/libexec/asdf.sh
. $(brew --prefix asdf)/etc/bash_completion.d/asdf.bash

# fzf settings
export FZF_DEFAULT_COMMAND='rg --files --follow --no-ignore-vcs --hidden -g "!{node_modules/*,.git/*}"'

# Git settings
#export PATH=$PATH:/usr/local/git/bin
export GITHUB_USER=tylerthehaas
#export GITHUB_PASS=

# Vim settings
set -o vi # for vi-mode command-line editing
set editing-mode vi # for vi-mode command-line editing and all utilities that use readline
export EDITOR=nvim
export VISUAL=nvim

# Don't retain duplicate commands in history.
export HISTCONTROL=ignoredups

export PATH=$HOME/.cargo/bin:$HOME/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:$PATH

#export TERM=xterm-256color-italic
export TERM=xterm-256color

source ~/.bashrc
