#!/usr/bin/env zsh
# ---------------------------------------
# Completion
# ---------------------------------------
fpath=(${HOME}/.config/zsh/completions $fpath)
# Load more completions
if type brew &>/dev/null; then
    fpath=($(brew --prefix)/share/zsh-completions $fpath)
fi

# Should be called before compinit
zmodload zsh/complist

# Use hjlk in menu selection (during completion)
# Doesn't work well with interactive mode
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# Initialize completions
autoload -U compinit; compinit
_comp_options+=(globdots) # With hidden files

# Options
setopt MENU_COMPLETE        # Automatically highlight first element of completion menu
setopt ALWAYS_TO_END        # Move cursor to the end of a completed word.
setopt AUTO_LIST            # Automatically list choices on ambiguous completion.
setopt COMPLETE_IN_WORD     # Complete from both ends of a word.
setopt AUTO_PARAM_SLASH     # If completed parameter is a directory, add a trailing slash.

# ----- zstyles -----
# :completion:<function>:<completer>:<command>:<argument>:<tag>

# Define completers
zstyle ':completion:*' completer _extensions _complete _approximate

# Use cache for commands using cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.cache/zcompcache"

# Allow you to select in a menu
zstyle ':completion:*' menu select

# Cosmetics
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %D %d --%f'
zstyle ':completion:*:*:*:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'
