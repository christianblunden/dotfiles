[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

export GPG_AGENT_INFO_FILE=$HOME/.gpg-agent-info
gpg-agent --daemon --enable-ssh-support --write-env-file "${GPG_AGENT_INFO_FILE}"
export GPG_TTY=$(tty)

source ~/.bashrc
