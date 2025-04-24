#!b/in/bash
unset COLUMNS # to prevent ps from truncating lines
set noclobber

# Files to ignore in filename completion.
export FIGNORE='.o:.swp'

# Look for libraries in standard places.
export LD_LIBRARY_PATH=.:$HOME/lib:/usr/local/lib:/usr/lib:$LD_LIBRARY_PATH

#-------------------------------------------------------------------------

export PATH="/Users/tyler.haas/.local/bin:$PATH"

# fzf settings
export FZF_DEFAULT_COMMAND='rg --files --follow --no-ignore-vcs --hidden -g "!{node_modules/*,.git/*}"'

# Git settings
export GITHUB_USER=tylerthehaas

# Vim settings
#set -o vi # for vi-mode command-line editing
#set editing-mode vi # for vi-mode command-line editing and all utilities that use readline
export EDITOR=lvim
export VISUAL=lvim

export PATH=$HOME/.cargo/bin:$HOME/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/Users/tylerhaas/.local/bin:$HOME/.bun/bin:$PATH

export TERM=xterm-256color

source ~/.bashrc
