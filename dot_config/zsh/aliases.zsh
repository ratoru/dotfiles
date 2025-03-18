#!/usr/bin/env zsh
# ---------------------------------------
# Aliases for common commands
# ---------------------------------------

# Fast navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias n="nvim"

# Aliases for tools.
if command -v eza &>/dev/null; then
    alias ls="eza --icons=auto -F -H --group-directories-first --git -1"
    alias ll="ls -alF"
    # Long form, groups, mark file types, order by last modified
    alias lt="eza -lgF -s oldest --icons"
else
    alias ll="ls -alF"
    alias lt="ls -lFt"
fi

alias lg='lazygit'
alias lzd='lazydocker'


# Empty the Trash on all mounted volumes and the main HDD.
# Also, clear Apple’s System Logs to improve shell startup speed.
# Finally, clear download history from quarantine. https://mths.be/bum
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"

# Hide/show all desktop icons (useful when presenting) -- macOS only
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# Sleep (when going AFK) -- macOS only
# Can lock the screen if system setting is set to require password immediately after sleep.
alias afk="pmset displaysleepnow"

# One of @janmoesen’s ProTip™s
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
    alias "${method}"="lwp-request -m '${method}'"
done

# Install updates for Homebrew (+ packages), and , npm (+ packages), and Rust.
alias update='brew update; brew upgrade; brew cleanup; npm install npm -g; npm update -g; rustup update'

# Find all files recursively and sort by last modified, ignore hidden files
alias lastmod='find . -type f -not -path "*/\.*" -exec ls -lrt {} +'
