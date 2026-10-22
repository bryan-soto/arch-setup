#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# --- bash_completion --- #
#if [ -f /etc/bash_completion ]; then
#  . /etc/bash_completion
#elif [ -r /usr/share/bash-completion/bash_completion ]; then
#  ./usr/share/bash-completion
#fi
[[ -r /usr/share/bash-completion/bash_completion ]] && source /usr/share/bash-completion/bash_completion
# ---  Zoxide --- #
eval "$(zoxide init bash)"

# --- Alias --- #
alias update="paru -Syu"
alias ls="eza --icons --group-directories-first"
alias ll="eza -lah --icons --group-directories-first"
alias la="eza -a --icons --group-directories-first"
alias cat="bat"
alias find="fd"
alias grep="rg"
alias cd="z"
alias man='LANG=es_MX:es man'
alias rm='echo "⚠️ Usa trash-put o tput para borrar seguro, o \\rm para borrar permanentemente."'
alias tput='trash-put'       # Mover a la papelera (Nuevo rm seguro)
alias tlist='trash-list'     # Ver contenido
alias trem='trash-rm'        # Borrar permanentemente de la papelera
alias tempty='trash-empty'   # Vaciar papelera
alias trest='trash-restore'  # Restaurar archivos

# --- FZF and commands --- #
source /usr/share/fzf/completion.bash
source /usr/share/fzf/key-bindings.bash

export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# --- Editor Neovim --- #
export EDITOR="nvim"

# ------ Prompt ------ #
BLUE="\[\e[34m\]"
GREEN="\[\e[32m\]"
RED="\[\e[31m\]"
RESET="\[\e[0m\]"

git_branch() {
  git branch --show-current 2>/dev/null
}

set_prompt() {
  local exit_code=$?
  local branch=""
  local status=""

  branch=$(git_branch)

  if [[ -n "$branch" ]]; then
    branch=" ${GREEN}[$branch]${RESET}"
  fi

  if [[ $exit_code -ne 0 ]]; then
    status="${RED}✗ ${RESET}"
  fi

  PS1="${BLUE}\W${RESET}${branch}\n${status}❯ "
}

PROMPT_COMMAND=set_prompt

# Agrega esto al final de tu ~/.bashrc o ~/.zshrc
export EZA_COLORS="di=38;5;250:ex=31:ln=35:so=32:pi=33:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43:ur=38;5;244:uw=38;5;244:ux=31:ue=31:gr=38;5;240:gw=38;5;240:gx=31:tr=38;5;240:tw=38;5;240:tx=31:sn=38;5;244:sb=38;5;244:df=38;5;244:ds=38;5;244:uu=38;5;250:gu=38;5;250:un=38;5;240:gn=38;5;240:lm=38;5;244:ga=38;5;244:gm=38;5;244:gd=38;5;244:gv=38;5;244:gt=38;5;244:gi=38;5;244:gc=38;5;244:da=38;5;244:in=38;5;240:bl=38;5;240:hd=38;5;240:lp=38;5;240:cc=38;5;240:co=38;5;240:re=38;5;244:do=38;5;244:sh=38;5;244:cx=38;5;244:cm=38;5;244:tm=38;5;244:ct=38;5;244:le=38;5;244:cl=38;5;244:ms=38;5;244:ts=38;5;244:me=38;5;244:bat=38;5;244:bkm=38;5;244:chr=38;5;244:comp=38;5;244:conf=38;5;244:crontab=38;5;244:crypto=38;5;244:css=38;5;244:deb=38;5;244:docker=38;5;244:doc=38;5;244:ebook=38;5;244:env=38;5;244:eslint=38;5;244:font=38;5;244:git=38;5;244:gtd=38;5;244:html=38;5;244:image=38;5;244:import=38;5;244:iso=38;5;244:js=38;5;244:json=38;5;244:key=38;5;244:legal=38;5;244:less=38;5;244:lib=38;5;244:lock=38;5;244:log=38;5;244:*.lua=38;5;255:make=38;5;244:markdown=38;5;244:music=38;5;244:out=38;5;244:pdf=38;5;244:playlist=37;5;244:pod=38;5;244:ps=38;5;244:*.py=38;5;255:rb=38;5;244:readme=38;5;244:rust=38;5;244:script=38;5;244:sh=38;5;244:sol=38;5;244:sql=38;5;244:sun=38;5;244:tex=38;5;244:text=38;5;244:tool=38;5;244:ts=38;5;244:video=38;5;244:vlc=38;5;244:xml=38;5;244:yaml=38;5;244:zip=38;5;244"
