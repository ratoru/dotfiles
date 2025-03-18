#!/usr/bin/env zsh
# ---------------------------------------
# Utility Functions
# ---------------------------------------

# Assume AWS Profile for current terminal session
function aws-prof() {
    if [ -z "$1" ]; then
        echo ${AWS_PROFILE}
    else
        export AWS_PROFILE=$@
    fi
}

# Create a new directory and enter it
function mkd() {
	mkdir -p "$@" && cd "$_";
}

# Change working directory to the top-most Finder window location -- macOS only
function cdf() { # short for `cdfinder`
    cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')";
}

# Determine size of a file or total size of a directory
function fs() {
    if du -b /dev/null >/dev/null 2>&1; then
	local arg=-sbh
    else
	local arg=-sh
    fi
    if [[ -n "$@" ]]; then
	du $arg -- "$@"
    else
	du $arg .[^.]* ./*
    fi
}

# Create a data URL from a file
function dataurl() {
    local mimeType=$(file -b --mime-type "$1")
    if [[ $mimeType == text/* ]]; then
	mimeType="${mimeType};charset=utf-8"
    fi
    echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}

# Recursively delete files that match a certain pattern
# (by default delete all `.DS_Store` files)
# Thanks @wilto - github.com/Wilto/dotfiles/blob/master/bash/functions/cleanup
function cleanup() {
    local q="${1:-*.DS_Store}"
    find . -type f -name "$q" -ls -delete
}

# README: Combine ripgrep, fzf, bat for very fancy CLI searching
# https://junegunn.github.io/fzf/tips/ripgrep-integration/
# ripgrep->fzf->vim [QUERY]
function rfv() (
    RELOAD='reload:rg --column --color=always --smart-case {q} || :'
    OPENER='if [[ $FZF_SELECT_COUNT -eq 0 ]]; then
            nvim {1} +{2}     # No selection. Open the current line in nvim.
          else
            nvim +cw -q {+f}  # Build quickfix list for the selected items.
          fi'
    fzf </dev/null \
	--disabled --ansi --multi \
	--bind "start:$RELOAD" --bind "change:$RELOAD" \
	--bind "enter:become:$OPENER" \
	--bind "ctrl-o:execute:$OPENER" \
	--bind 'alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview' \
	--delimiter : \
	--preview 'bat --style=full --color=always --highlight-line {2} {1}' \
	--preview-window '~4,+{2}+4/3,<80(up)' \
	--query "$*"
)

# Change ghostty config on the fly.
function ghosttyc {
  local GHOSTTY_DIR="$HOME/.config/ghostty"
  local CMD="sed -i '' 's:\(config-file = {1}\)/.*:\1/{2}:' $GHOSTTY_DIR/config && osascript -so -e 'tell application \"Ghostty\" to activate' -e 'tell application \"System Events\" to keystroke \",\" using {command down, shift down}'"
  fd \
    --type f \
    --exclude 'config' \
    --exclude 'README.md' \
    --base-directory $GHOSTTY_DIR \
  | fzf \
    --style full \
    --layout=reverse \
    --list-label=" Settings " \
    --preview "bat --color=always --style=numbers -l INI $GHOSTTY_DIR/{}" \
    --preview-label=" Preview " \
    --delimiter=/ \
    --bind="enter:become:$CMD"
}

# Tree replacement using broot.
function tree {
     br -c :pt "$@"
}

# Show most used commands
function historystat {
    history 0 | awk '{print $2}' | sort | uniq -c | sort -n -r | head
}

# Measure the prompt speed
function promptspeed {
    for i in $(seq 1 10); do /usr/bin/time zsh -i -c exit; done
}

# Fzf over open ports
function ports {
    sudo netstat -tulpn | grep LISTEN | fzf;
}
