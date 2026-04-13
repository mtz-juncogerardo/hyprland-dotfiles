# PATH - include local bin for claude and other tools
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# Using custom Catppuccin Mocha prompt (defined below)
ZSH_THEME=""

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
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions)

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

# ─── Atom Dark Prompt ─────────────────────────────────────
# Colors from Atom Dark palette
local ctp_mauve="%F{#c678dd}"
local ctp_blue="%F{#61afef}"
local ctp_green="%F{#98c379}"
local ctp_peach="%F{#d19a66}"
local ctp_red="%F{#e06c75}"
local ctp_teal="%F{#56b6c2}"
local ctp_yellow="%F{#e5c07b}"
local ctp_text="%F{#abb2bf}"
local ctp_subtext="%F{#828997}"
local ctp_overlay="%F{#5c6370}"
local reset="%f"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#5c6370"

# ─── Git prompt info ────────────────────────────────────────────
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "${ctp_green}+${reset}"
zstyle ':vcs_info:git:*' unstagedstr "${ctp_red}!${reset}"
zstyle ':vcs_info:git:*' formats " ${ctp_overlay}on${reset} ${ctp_peach} %b${reset}%c%u"
zstyle ':vcs_info:git:*' actionformats " ${ctp_overlay}on${reset} ${ctp_peach} %b${reset}|${ctp_peach}%a${reset}%c%u"

# Untracked files indicator (vcs_info doesn't do this natively)
prompt_git_untracked() {
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    if [[ -n $(git ls-files --others --exclude-standard 2>/dev/null) ]]; then
      echo "${ctp_yellow}?${reset}"
    fi
  fi
}

# ─── Build the prompt ───────────────────────────────────────────
# Line 1: ╭─ user@host in ~/path on  branch +!?
# Line 2: ╰─❯ (green on success, red on failure)
PROMPT='${ctp_blue}╭─${reset}${ctp_blue}${reset} ${ctp_subtext}%n${reset}${ctp_subtext}@${reset}${ctp_subtext}%m${reset} ${ctp_overlay}in${reset} ${ctp_teal}%~${reset}${vcs_info_msg_0_}$(prompt_git_untracked)
${ctp_blue}╰─${reset}%(?.${ctp_blue}.${ctp_red})❯${reset} '

RPROMPT='${ctp_blue}%*${reset}'

# ─── Completion settings ─────────────────────────────────────────
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ─── Catppuccin syntax highlighting theme ────────────────────────
source ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh


# ─── fzf integration ────────────────────────────────────────
source <(fzf --zsh)

# Bind Up arrow to fzf history search
fzf-history-widget-up() {
  fzf-history-widget
}
zle -N fzf-history-widget-up
bindkey '^[[A' fzf-history-widget-up
bindkey '^[OA' fzf-history-widget-up

# Load Angular CLI autocompletion.
source <(ng completion script)
export PATH="$HOME/.dotnet/tools:$PATH"

#fastfetch
hyfetch -b fastfetch

# ─── Dev mode ────────────────────────────────────────────────
devmode() {
  local project=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --project) project="$2"; shift 2 ;;
      *) shift ;;
    esac
  done

  echo "Starting dev environment..."

  # PostgreSQL
  if ! systemctl is-active --quiet postgresql; then
    echo "Starting PostgreSQL..."
    sudo systemctl start postgresql
  else
    echo "PostgreSQL already running."
  fi

  if [[ -n "$project" ]]; then
    local project_dir="$HOME/repos/$project"
    if [[ ! -d "$project_dir" ]]; then
      echo "Project not found: $project_dir"
      cd ~/repos
      # Fallback: launch apps normally
      webstorm &>/dev/null &
      rider &>/dev/null &
      disown
    else
      cd "$project_dir" && echo "Switched to $project_dir."
      # Workspace 2: WebStorm + Claude Web | Workspace 3: Rider + Claude API
      hyprctl dispatch exec "[workspace 2] kitty --title 'Claude - Web ($project)' --working-directory '$project_dir/Web' -e claude"
      hyprctl dispatch exec "[workspace 2] webstorm"
      hyprctl dispatch exec "[workspace 3] rider"
      hyprctl dispatch exec "[workspace 3] kitty --title 'Claude - API ($project)' --working-directory '$project_dir/API' -e claude"
      echo "Launched: ws2=WebStorm+Claude Web, ws3=Rider+Claude API."
    fi
  else
    # No project: launch apps on current workspace
    obsidian &>/dev/null &
    webstorm &>/dev/null &
    rider &>/dev/null &
    disown
    cd ~/repos && echo "Switched to ~/repos. Dev mode ready."
  fi
}
