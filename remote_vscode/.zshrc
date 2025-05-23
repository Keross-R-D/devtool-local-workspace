# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# Custom aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Environment variables
export EDITOR='vim'
export PATH="$HOME/bin:$PATH"

# Set JAVA_HOME and add to PATH for Java
export JAVA_HOME=${JAVA_INSTALL_DIR}
export PATH="$JAVA_HOME/bin:$PATH"

HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_VERIFY

autoload -U compinit
compinit