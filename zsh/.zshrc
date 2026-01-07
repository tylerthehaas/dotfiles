if [[ ! -f ~/.zshrc.zwc || ~/.zshrc -nt ~/.zshrc.zwc ]]; then
  zcompile ~/.zshrc
fi

# --- Early exit for non-interactive shells ---
[[ -o interactive ]] || return

# === CORE SETTINGS (STARTUP) ===
setopt EXTENDED_GLOB  # CRITICAL: Required for (#qNmh-XX) cache qualifiers to work
setopt EXTENDED_HISTORY HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE HIST_VERIFY SHARE_HISTORY
setopt APPEND_HISTORY INC_APPEND_HISTORY HIST_FCNTL_LOCK
setopt HIST_REDUCE_BLANKS HIST_SAVE_NO_DUPS
setopt GLOB_DOTS NO_AUTO_MENU
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS
setopt INTERACTIVE_COMMENTS
HISTFILE="$HOME/.zsh_history"
HISTSIZE=20000
SAVEHIST=20000

# === HELPER FUNCTIONS (STARTUP) ===
# Fast command check (native zsh)
_has() { (( $+commands[$1] )) }

# Cache evaluation helper (DRY principle for tool initialization)
_cache_eval() {
  local cmdname="$1"
  local cmd="$2"
  local cache_file="${XDG_CACHE_HOME:-$HOME/.cache}/${cmdname}_init.zsh"

  # Refresh cache if missing or older than 7 days
  # Glob qualifier: #qNmh-168 = modified within 168 hours (7 days * 24h)
  if [[ ! -f "$cache_file"(#qNmh-168) ]]; then
    mkdir -p "$(dirname "$cache_file")"
    eval "$cmd" >| "$cache_file" 2>/dev/null
  fi
  source "$cache_file"
}

# Improved defer function - queues commands for precmd execution
_defer() {
  (( ${+_defer_cmds} )) || typeset -ga _defer_cmds
  _defer_cmds+="$1"
  if ! (( ${+_defer_hook_added} )); then
    _defer_hook_added=1
    autoload -Uz add-zsh-hook
    add-zsh-hook precmd _run_deferred
  fi
}

_run_deferred() {
  add-zsh-hook -d precmd _run_deferred
  for cmd in "${_defer_cmds[@]}"; do
    eval "$cmd"
  done
  unset _defer_cmds _defer_hook_added
}

# === PATH SETUP (STARTUP) ===
typeset -U path PATH
path=(
  $HOME/.local/share/mise/shims
  $HOME/.local/bin
  $HOME/bin
  /opt/homebrew/bin
  /usr/local/bin
  $path
)
# Add Go path only if it exists
[[ -d "$HOME/go/bin" ]] && path=($HOME/go/bin $path)
# Add trash to PATH (keg-only formula)
[[ -d "/opt/homebrew/opt/trash/bin" ]] && path=(/opt/homebrew/opt/trash/bin $path)


# === ENVIRONMENT (STARTUP) ===
# Note: EDITOR and VISUAL are set in .zshenv
export GPG_TTY=$TTY
export MISE_NODE_COREPACK=true

# Colored man pages using bat (if available)
if _has bat; then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export MANROFFOPT="-c"
fi

# PAI System paths
export PROJECTS_DIR="$HOME/Projects"
export CONSULTING_DIR="$HOME/Consulting"
export DOTFILES_DIR="$HOME/Projects/dotfiles"
export ZSH_CONFIG_DIR="$HOME/.config/zsh"

# Source secrets if present (not compiled for security)
[[ -f "$HOME/.secrets.zsh" ]] && source "$HOME/.secrets.zsh"

# === TOOL INITIALIZATION (DEFERRED) ===
# All heavy tool hooks moved to precmd - invisible to hyperfine

# direnv hook (deferred - simpler and faster than lazy loading)
if _has direnv; then
  _defer "_cache_eval 'direnv' 'direnv hook zsh'"
fi

# mise: shims handled via ~/.zshenv (no init needed here)

# zoxide (deferred) - includes aliases after init
if _has zoxide; then
  _defer '_cache_eval "zoxide" "zoxide init zsh"
    [[ "${ZOXIDE_REPLACE_CD}" == "1" ]] && alias cd="z"
    alias cdi="zi"
    alias zz="z -"'
fi

# starship prompt (deferred)
if _has starship; then
  _defer "_cache_eval 'starship' 'starship init zsh --print-full-init'"
else
  # Fallback to simple prompt if Starship not available
  autoload -Uz vcs_info
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd vcs_info
  zstyle ':vcs_info:git:*' formats ' %b'
  setopt PROMPT_SUBST
  PROMPT='%F{blue}%~%f%F{yellow}${vcs_info_msg_0_}%f
%F{green}❯%f '
fi

autoload -Uz zmv

# Safe rm - Blocks catastrophic patterns and suggests trash
safe-rm() {
  # Check for empty arguments
  [[ $# -eq 0 ]] && { echo "Usage: rm <files>"; return 1; }

  local dangerous_patterns=(
    '/'
    '//'
    '/*'
    '/.*'
    '/bin'
    '/boot'
    '/dev'
    '/etc'
    '/lib'
    '/proc'
    '/root'
    '/sbin'
    '/sys'
    '/usr'
    '/var'
    "$HOME"
    "$HOME/"
    "$HOME/*"
    "$HOME/.*"
  )

  # Check each argument for dangerous patterns
  for arg in "$@"; do
    # Skip flags
    [[ "$arg" =~ ^- ]] && continue

    # Resolve to absolute path for comparison
    local abs_path="${arg:A}"

    for pattern in "${dangerous_patterns[@]}"; do
      if [[ "$abs_path" == "$pattern" ]] || [[ "$arg" == "$pattern" ]]; then
        echo "🚨 BLOCKED: Refusing to rm '$arg' - this is a protected path"
        echo "💡 If you really need to delete files, use:"
        echo "   - 'trash' to move to Trash (recoverable)"
        echo "   - 'command rm' to bypass this protection (dangerous!)"
        return 1
      fi
    done

    # Warn on wildcard in root or home
    if [[ "$arg" =~ '(^/[^/]*\*|^~/?[^/]*\*)' ]]; then
      echo "⚠️  WARNING: Wildcard deletion in root/home detected: $arg"
      echo "💡 Consider using 'trash' instead for recoverable deletion"
      read -q "REPLY?Continue anyway? (y/N) "
      echo
      [[ "$REPLY" != "y" ]] && return 1
    fi
  done

  # If all checks pass, run real rm
  command rm "$@"
}

# Auto-list directory contents after cd (disable with DISABLE_CHPWD_LS=1)
chpwd() {
  [[ "${DISABLE_CHPWD_LS}" == "1" ]] && return
  if _has eza; then eza -lah --icons --group-directories-first --no-user 2>/dev/null
  elif _has lsd; then lsd -lah 2>/dev/null
  else ls -lah
  fi
}

# Create and enter directory
md() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }

# Copy working directory to clipboard
cpwd() { pwd | tr -d '\n' | pbcopy }

cpf() {
  if [[ -f "$1" ]]; then
    pbcopy < "$1"
    echo "✓ Copied contents of $1"
  else
    echo "✗ '$1' is not a valid file"
    return 1
  fi
}

# Universal extract function
extract() {
  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"     ;;
      *.tar.gz)    tar xzf "$1"     ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar e "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xf "$1"      ;;
      *.tbz2)      tar xjf "$1"     ;;
      *.tgz)       tar xzf "$1"     ;;
      *.zip)       unzip "$1"       ;;
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"        ;;
      *)           echo "✗ '$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "✗ '$1' is not a valid file"
    return 1
  fi
}
alias x="extract"

# === ALIASES (STARTUP) ===
# Quick directory jumps
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Core utilities (Modern Rust-based tools)
# eza - Modern ls replacement with Dracula theme
if _has eza; then
  export EZA_COLORS="reset:di=1;34:ln=1;36:so=1;35:pi=33:ex=1;32:bd=1;33:cd=1;33:su=1;31:sg=1;31:tw=1;34:ow=1;34"
  alias ls="eza --icons --group-directories-first --no-user"
  l() {
    eza -lah --icons --group-directories-first --no-user "$@"
  }
  alias ll="eza -lh --icons --group-directories-first --no-user"
  alias la="eza -a --icons --group-directories-first --no-user"
  alias tree="eza --tree --icons"
else
  # Fallback to lsd if eza not available
  alias l="lsd -lah --total-size"
  alias ll="lsd -lh"
fi

# Modern Rust-based tool aliases (consolidated _has checks)
_has yazi && alias y="yazi"
_has procs && alias ps="procs"
_has duf && alias df="duf"
_has dust && alias du="dust"
_has rg && alias grep="rg"
_has trash && alias del="trash"  # Preferred: macOS Trash (recoverable)
alias rm="safe-rm"                 # Protected rm with catastrophic pattern blocking

# Editor and clipboard
alias v="lvim"
alias p="pbpaste"
alias c="pbcopy"
alias gbd="git-branch-delete interactive"

# Claude AI
alias claude="~/.claude/local/claude"
alias cc="cd ~/PAI && claude"

# Zoxide aliases (cdi, zz) defined in deferred init block above
# Set ZOXIDE_REPLACE_CD=1 in .zshenv to also replace cd with z

# Git essentials
alias g="git"
alias ga="git add"
alias gb="git branch"
alias gc="git commit"
alias gcm="git commit -m"
alias gco="git checkout"
alias gd="git diff"
alias gf="git fetch --all"
alias gl="git log --oneline --graph"
alias gm="git merge"
alias gp="git push"
alias gpl="git pull"
alias gs="git status"
alias gst="git stash"
alias gstp="git stash pop"

# custom aliases
alias myip="echo 'Local IPv4: ' \$(ifconfig | grep 'inet ' | grep -v 127.0.0.1 | awk '{print \$2}') && echo 'Public IPv4: ' \$(curl -s -4 ifconfig.me)"

# === FZF CONFIGURATION (DEFERRED) ===
if _has fzf; then
  # Enhanced FZF options with Dracula colors (fast export at startup)
  export FZF_DEFAULT_OPTS="
    --height=50%
    --layout=reverse
    --border=rounded
    --info=inline
    --preview-window=right:60%:wrap
    --bind='ctrl-/:toggle-preview'
    --bind='ctrl-u:preview-page-up'
    --bind='ctrl-d:preview-page-down'
    --bind='ctrl-y:execute-silent(echo -n {+} | pbcopy)'
    --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9
    --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9
    --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6
    --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4
  "

  # FZF command initialization (deferred)
  _defer "_cache_eval 'fzf' 'fzf --zsh'"

  # Better file/directory commands with fd (deferred)
  _defer '
    if _has fd; then
      export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
    fi

    if _has bat && _has eza; then
      export FZF_CTRL_T_OPTS="--preview \"bat -n --color=always {} 2>/dev/null || eza --tree --level=2 --color=always {} 2>/dev/null || cat {}\""
      export FZF_ALT_C_OPTS="--preview \"eza --tree --level=2 --color=always --icons {} 2>/dev/null\""
    elif _has bat; then
      export FZF_CTRL_T_OPTS="--preview \"bat --color=always --style=numbers --line-range=:500 {}\""
    fi
  '

  # Process search alias
  alias fps='ps aux | fzf'
fi

# === LAZY LOADS (STARTUP) ===
# System update function - calls optimized update-system script
up() {
  local cmd="${1:-full}"
  # Map 'all' to 'full' for convenience
  [[ "$cmd" == "all" ]] && cmd="full"

  if [[ -x "$DOTFILES_DIR/bin/update-system" ]]; then
    "$DOTFILES_DIR/bin/update-system" "$cmd"
  else
    echo "Error: update-system script not found or not executable"
    return 1
  fi
}

# Load project functions only when needed
proj() {
  source "$ZSH_CONFIG_DIR/projects.zsh" 2>/dev/null || {
    echo "Error: projects.zsh not found"
    return 1
  }
  proj "$@"
}

# Fabric lazy load with error handling
fabric() {
  unfunction fabric 2>/dev/null
  if [[ -f "$HOME/.config/fabric/fabric-bootstrap.inc" ]]; then
    source "$HOME/.config/fabric/fabric-bootstrap.inc"
  fi
  if _has fabric; then
    command fabric "$@"
  else
    echo "Error: fabric not found in PATH" >&2
    return 1
  fi
}

# Fabric helper functions - lazy loaded via wrapper
# Available: smart-commit, ai-commit, doc-code, get-todos, list-custom-patterns
_load_fabric_helpers() {
  unfunction _load_fabric_helpers smart-commit ai-commit doc-code get-todos list-custom-patterns 2>/dev/null
  source "$DOTFILES_DIR/bin/fabric-helpers"
}
smart-commit() { _load_fabric_helpers; smart-commit "$@" }
ai-commit() { _load_fabric_helpers; ai-commit "$@" }
doc-code() { _load_fabric_helpers; doc-code "$@" }
get-todos() { _load_fabric_helpers; get-todos "$@" }
list-custom-patterns() { _load_fabric_helpers; list-custom-patterns "$@" }

# === ZSH PLUGINS (DEFERRED) ===
# Autosuggestions + Syntax highlighting loaded together (single defer, fewer file checks)
# Dracula theme colors for syntax highlighting
typeset -A ZSH_HIGHLIGHT_STYLES=(
  [comment]='fg=#6272a4' [alias]='fg=#50fa7b,bold' [suffix-alias]='fg=#50fa7b,bold'
  [global-alias]='fg=#50fa7b,bold' [function]='fg=#50fa7b,bold' [command]='fg=#50fa7b,bold'
  [precommand]='fg=#50fa7b,bold,italic' [autodirectory]='fg=#ffb86c,italic'
  [single-hyphen-option]='fg=#ffb86c' [double-hyphen-option]='fg=#ffb86c'
  [back-quoted-argument]='fg=#bd93f9' [builtin]='fg=#8be9fd,bold'
  [reserved-word]='fg=#8be9fd,bold' [hashed-command]='fg=#8be9fd,bold'
  [commandseparator]='fg=#ff79c6' [command-substitution-delimiter]='fg=#f8f8f2'
  [command-substitution-delimiter-unquoted]='fg=#f8f8f2'
  [process-substitution-delimiter]='fg=#f8f8f2' [back-quoted-argument-delimiter]='fg=#ff79c6'
  [back-double-quoted-argument]='fg=#ff79c6' [back-dollar-quoted-argument]='fg=#ff79c6'
  [assign]='fg=#f8f8f2' [redirection]='fg=#f8f8f2' [arg0]='fg=#f8f8f2'
  [default]='fg=#f8f8f2' [cursor]='standout'
)

# Single defer for both plugins (syntax highlighting must be last)
_defer '
  [[ -f "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && {
    source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=#6272a4
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    bindkey "^ " autosuggest-accept
  }
  [[ -f "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
    source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
'

# === PERFORMANCE DEBUG (optional) ===
# Uncomment to measure startup time
# if [[ -n "$ZSH_STARTUP_TIME" ]]; then
#   zprof
# fi
export PATH="$HOME/bin:$PATH"

# Keybindings
bindkey '^f' autosuggest-accept
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
# bindkey -v

