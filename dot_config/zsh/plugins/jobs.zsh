# ---------------------------------------
# Job Control / "Fancy Suspend" Setup
# ---------------------------------------
# https://jkrl.me/shell/2025/11/28/suspending-shell-processes.html
jobs_widget() {
    zle -I
    jobs
}
zle -N jobs_widget

# Brings the current job (%) to foreground
fg_current_widget() {
    zle -I
    fg %+
}
zle -N fg_current_widget

# Brings the previous job (%-) to foreground (Toggle between 2 apps)
fg_prev_widget() {
    zle -I
    fg %-
}
zle -N fg_prev_widget

# Kills the current job
kill_job_current_widget() {
    if [[ -n "$(jobs)" ]]; then
        zle -I
        kill %+
    fi
}
zle -N kill_job_current_widget

# Resume job $i$
fg_numbered_widget() {
    # Extract the last character of the key sequence (the number)
    local job_id="${KEYS: -1}"

    zle -I
    if [[ -n "$(jobs %$job_id 2>/dev/null)" ]]; then
        fg %$job_id
    else
        echo "Job %$job_id not found."
    fi
}
zle -N fg_numbered_widget

# Kill job $i$
kill_numbered_widget() {
    local job_id="${KEYS: -1}"

    zle -I
    if [[ -n "$(jobs %$job_id 2>/dev/null)" ]]; then
        kill %$job_id && zle -M "Job %$job_id killed."
    else
        echo "Job %$job_id not found."
    fi
}
zle -N kill_numbered_widget

# If you press Ctrl-Z at an empty prompt, it runs 'fg'.
# This lets you toggle in and out of an app with the same key.
fancy_ctrl_z() {
    if [[ $#BUFFER -eq 0 ]]; then
        fg_current_widget
    else
        zle push-input
        zle clear-screen
    fi
}
zle -N fancy_ctrl_z

# ---------------------------------------
# BINDINGS (Using Ctrl-b as Leader)
# ---------------------------------------
# Unbind Ctrl-b from all maps so it doesn't "self-insert"
bindkey -r '^B'
bindkey -M viins -r '^B'
bindkey -M vicmd -r '^B'

bind_all() {
    bindkey -M viins "$1" "$2"
    bindkey -M vicmd "$1" "$2"
}

bind_all '^B^B' jobs_widget
bind_all '^B^F' fg_current_widget
bind_all '^B^P' fg_prev_widget
bind_all '^Bk' kill_job_current_widget
bind_all '^Z' fancy_ctrl_z

for i in {1..9}; do
    bind_all "^B${i}" fg_numbered_widget
    # bind_all "^Bk${i}" kill_numbered_widget
done
