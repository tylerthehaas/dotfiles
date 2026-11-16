# dotfiles

macOS dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).
Each top-level folder (`zsh/`, `git/`, `nvim/`, ...) is a stow package laid
out as it should appear under `$HOME`. For example, `zsh/.zshrc` links to
`~/.zshrc`.

Tools come from two places:

| Manager  | File                                         | Owns                                                          |
| -------- | -------------------------------------------- | ------------------------------------------------------------- |
| Homebrew | [`homebrew/.Brewfile`](homebrew/.Brewfile)   | zsh plugins, stow, bat, fd, direnv, and other non-mise CLIs   |
| mise     | [`mise/.config/mise/config.toml`](mise/.config/mise/config.toml) | language runtimes, fzf, eza, zoxide, starship, ripgrep, neovim, gh, ... |

## Set up a new machine

Run these in order in Terminal. The repo must be cloned to `~/dotfiles`:
stow links into the folder above the repo, and `.zshrc` expects
`$DOTFILES_DIR=~/dotfiles`.

**1. Command line tools and Homebrew**

```bash
xcode-select --install
```

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

**2. Clone this repo**

```bash
git clone https://github.com/tylerthehaas/dotfiles.git ~/dotfiles
```

(Use `git@github.com:tylerthehaas/dotfiles.git` instead once your SSH key is
on GitHub.)

**3. Install the Homebrew packages** (this also installs `stow`)

```bash
brew bundle --file ~/dotfiles/homebrew/.Brewfile
```

**4. Link the dotfiles into `$HOME`**

```bash
cd ~/dotfiles && stow bash bin eslint ghostty git homebrew kitty mise nvim ohmyposh starship tmux zsh
```

If stow reports a conflict, a real file already exists where it wants to put
a link (for example a default `~/.zshrc`). Move that file aside
(`mv ~/.zshrc ~/.zshrc.bak`) and run the command again.

**5. Install mise and its tools**

```bash
curl https://mise.run | sh
```

```bash
~/.local/bin/mise install
```

Do this before opening a new shell: `.zshenv` sources `~/.cargo/env`, and
that file only exists once mise has installed rust.

**6. Start a fresh shell**

```bash
exec zsh
```

Optional: put machine-specific secrets (API tokens and so on) in
`~/.secrets.zsh`. `.zshrc` sources it when it exists, and it is never
committed.

## Day to day

| Task                                   | Command                                      |
| -------------------------------------- | -------------------------------------------- |
| Install anything new in the Brewfile   | `brew bundle --global`                       |
| Check every Brewfile package is there  | `brew bundle check --global`                 |
| Install / update mise tools            | `mise install` / `mise upgrade`              |
| Link a new or changed package          | `cd ~/dotfiles && stow <package>`            |
| Reload zsh after editing the config    | `exec zsh` (safer than `source ~/.zshrc`)    |

`~/.Brewfile` is a symlink to `homebrew/.Brewfile`, so `brew bundle --global`
always uses the tracked file. The Brewfile doesn't track GUI apps (casks), so
never run `brew bundle cleanup --force`: it would uninstall them.
