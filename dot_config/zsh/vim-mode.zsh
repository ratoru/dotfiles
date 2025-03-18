#!/usr/bin/env zsh
# ---------------------------------------
# Vim Mode
# ---------------------------------------

# Vim mode
bindkey -v
# Switch between modes faster
export KEYTIMEOUT=1

# Edit line in $EDITOR (= nvim) by pressing `v`
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Cursor Shape
function zle-keymap-select {
    if [[ ${KEYMAP} == vicmd ]] ||
	[[ $1 = 'block' ]]; then
	echo -ne '\e[2 q'
    elif [[ ${KEYMAP} == main ]] ||
	[[ ${KEYMAP} == viins ]] ||
	[[ ${KEYMAP} = '' ]] ||
	[[ $1 = 'beam' ]]; then
	echo -ne '\e[6 q'
    fi
}
function zle-line-init() {
    echo -ne '\e[6 q'
}

zle -N zle-keymap-select
zle -N zle-line-init
