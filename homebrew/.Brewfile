# ~/.Brewfile: Homebrew packages the zsh config (zsh/.zshrc, zsh/.zshenv) needs.
# Stowed from ~/dotfiles/homebrew (`cd ~/dotfiles && stow homebrew`).
#
#   brew bundle --global           # install anything missing
#   brew bundle check --global     # exit 0 when everything here is installed
#
# Scope: only what Homebrew should own. Language runtimes and the CLI tools
# that mise manages (fzf, eza, zoxide, ripgrep, neovim, starship, gh, glab,
# lazygit, ...) live in mise/.config/mise/config.toml. Don't add them here too,
# or you'll end up with two copies fighting over PATH.
#
# Not tracked: GUI apps (casks). Because of that, DON'T run
# `brew bundle cleanup --force`: it would uninstall every cask.

tap "octopusdeploy/taps"

# --- zsh plugins (sourced from $HOMEBREW_PREFIX/share in .zshrc) ---
brew "fzf-tab"                 # Tab completion through fzf; needs fzf (from mise)
brew "zsh-autosuggestions"     # history-based suggestions, ^f / ^space to accept
brew "zsh-syntax-highlighting" # must load last; .zshrc handles the order

# --- tools the zsh config calls directly ---
brew "stow"                    # symlinks this dotfiles repo into $HOME
brew "bat"                     # `cat` alias, MANPAGER, fzf / fzf-tab previews
brew "fd"                      # FZF_DEFAULT_COMMAND / Ctrl-T / Alt-C file search
brew "direnv"                  # per-directory env; hook is deferred in .zshrc

# --- other CLIs already installed via Homebrew ---
brew "octopusdeploy/taps/octopus-cli" # OCTOPUS_* vars are set in .zshenv

# --- optional: .zshrc aliases these only when installed ---
# They aren't installed yet. Uncommenting one changes a command you use now:
# procs breaks `fps` (ps aux | fzf), because procs reads "aux" as a search term.
# brew "yazi"                  # y   -> yazi file manager
# brew "procs"                 # ps  -> procs
# brew "duf"                   # df  -> duf
# brew "dust"                  # du  -> dust
