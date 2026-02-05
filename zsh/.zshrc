# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias ghpr="gh pr create --fill"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
export PATH="/opt/homebrew/opt/node@18/bin:$PATH"

export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

# GAR (Google Artifact Registry) auto-login
function gar_login() {
  if gcloud auth print-access-token &>/dev/null; then
    echo "Already logged in to gcloud. Refreshing GAR token..."
    npx --registry=https://registry.npmjs.org google-artifactregistry-auth
  else
    echo "Not logged in. Running full auth flow..."
    node ~/scripts/gcloud-auth/auth.js && npx --registry=https://registry.npmjs.org google-artifactregistry-auth
  fi
}

gar_login

# Added by Windsurf
export PATH="/Users/karmal/.codeium/windsurf/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Creates a new docker simlink if there is none or if there is an invalid one
ls -lah /var/run/docker.sock 2>&1 | grep .rd/docker.sock > /dev/null || ( sudo rm -f /var/run/docker.sock 2>&1 > /dev/null && sudo ln -s ~/.rd/docker.sock /var/run/docker.sock )

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/karmal/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

. "$HOME/.local/bin/env"

# Added by Antigravity
export PATH="/Users/karmal/.antigravity/antigravity/bin:$PATH"


alias fixaudio="sudo killall coreaudiod"
alias maestro-ios='maestro --device $(xcrun simctl list devices booted -j | jq -r ".devices[][] | select(.state==\"Booted\") | .udid" | head -1)'
# eza (modern ls)
alias ls="eza --icons"
alias ll="eza -l --git --icons"
alias la="eza -la --git --icons"
alias lt="eza --tree --level=2 --icons"

# bat (modern cat)
alias cat="bat"

# fzf (fuzzy finder)
source <(fzf --zsh)

# zoxide (smarter cd)
eval "$(zoxide init zsh)"

# lazygit
alias lg="lazygit"

alias c="claude"
alias yolo="claude --dangerously-skip-permissions"
alias co="code ."

# Zellij layouts
zj() {
  zellij attach "$1" 2>/dev/null || {
    zellij delete-session "$1" 2>/dev/null
    zellij -s "$1" -n "$2"
  }
}
alias zwork="zj work ~/.config/zellij/layouts/work.kdl"
alias zrek="zj reklamblad ~/.config/zellij/layouts/reklamblad.kdl"
alias zexp="zj expenses ~/.config/zellij/layouts/expenses.kdl"
alias znot="zj notera-cli ~/.config/zellij/layouts/notera-cli.kdl"
alias zccd="zj claude-code-desktop ~/.config/zellij/layouts/claude-code-desktop.kdl"
alias zpause="zj pause ~/.config/zellij/layouts/pause.kdl"
alias zpin="zj pinpoint ~/.config/zellij/layouts/pinpoint.kdl"
alias zls="zellij list-sessions"
export CLAUDE_CODE_USE_VERTEX=1
export CLOUD_ML_REGION=europe-west1
export ANTHROPIC_VERTEX_PROJECT_ID=ai-dev-tools-prod-57391

# GitHub Personal Access Token for Claude Code
export GITHUB_PERSONAL_ACCESS_TOKEN="REPLACE_WITH_NEW_TOKEN"
alias nnlogin="~/scripts/appLogin/login.sh"

# bun completions
[ -s "/Users/karmal/.bun/_bun" ] && source "/Users/karmal/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH=$PATH:$HOME/go/bin

# notera completions
fpath=(~/.oh-my-zsh/custom/completions $fpath)
