# Ralph - The AI Loop

ralph() {
    # 1. Safety Options
    # emulate -L zsh ensures standard zsh behavior inside this function
    emulate -L zsh
    setopt err_return pipe_fail no_unset

    # 2. Config & Dependencies
    (( $+commands[claude] )) || { print -u2 "Error: 'claude' CLI not found."; return 1; }
    (( $+commands[git] )) || { print -u2 "Error: 'git' not found."; return 1; }

    # Use system /tmp to guarantee agent isolation
    local PROJECT_NAME=${${PWD##*/}:-unknown_project}
    local LOG_DIR="/tmp/ralph_logs/$PROJECT_NAME"
    mkdir -p "$LOG_DIR"

    # 3. Parse Arguments
    local MODE="build"
    local PROMPT_FILE="PROMPT_build.md"
    local MAX_ITERATIONS=0

    if [[ "${1:-}" == "plan" ]]; then
        MODE="plan"
        PROMPT_FILE="PROMPT_plan.md"
        MAX_ITERATIONS=${2:-0}
    elif [[ "${1:-}" =~ ^[0-9]+$ ]]; then
        MAX_ITERATIONS=$1
    fi

    # 4. Path Resolution (Local Only)
    local PROMPT_PATH="$PWD/$PROMPT_FILE"

    # Final Validation
    if [[ ! -f "$PROMPT_PATH" ]]; then
        print -u2 "Error: Prompt file not found."
        print -u2 "Checked: $PROMPT_PATH"
        print -u2 "Please ensure '$PROMPT_FILE' exists in your current directory."
        return 1
    fi

    local CURRENT_BRANCH=$(git branch --show-current)

    print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print "Mode:     $MODE"
    print "Prompt:   $PROMPT_FILE"
    print "Branch:   $CURRENT_BRANCH"
    print "Logs:     $LOG_DIR/"
    [[ "$MAX_ITERATIONS" -gt 0 ]] && print "Max:      $MAX_ITERATIONS iterations"
    print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    # 5. Main Loop
    local ITERATION=0
    while true; do
        if [[ "$MAX_ITERATIONS" -gt 0 && "$ITERATION" -ge "$MAX_ITERATIONS" ]]; then
            print "Reached max iterations: $MAX_ITERATIONS"
            break
        fi

        ((ITERATION++))
        local TIMESTAMP=$(date +%Y%m%d_%H%M%S)
        local LOG_FILE="$LOG_DIR/${TIMESTAMP}_iter_${ITERATION}.log"

        print "\n=== LOOP $ITERATION STARTING ==="

        # Run Agent. Disable 'err_return' temporarily so API failures don't kill the loop
        setopt +o err_return
        cat "$PROMPT_PATH" | claude -p \
            --dangerously-skip-permissions \
            --output-format=stream-json \
            --model opus \
            --verbose | tee "$LOG_FILE"
        local CLAUDE_EXIT_CODE=$?
        setopt err_return

        if [[ $CLAUDE_EXIT_CODE -ne 0 ]]; then
            print "Warning: Claude CLI exited with error code $CLAUDE_EXIT_CODE. Check logs."
        fi

        # Push changes if any commits happened
        git push origin "$CURRENT_BRANCH" || {
            print "Push failed (or nothing to push). Attempting upstream set..."
            git push -u origin "$CURRENT_BRANCH" || true
        }

        print "\n=== LOOP $ITERATION COMPLETE (Log: $LOG_FILE) ===\n"
    done
}
