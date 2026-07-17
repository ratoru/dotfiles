#!/usr/bin/env zsh
#
# Claude Code statusline. Edit the *_FG colors below, or the `left+=`/
# `right+=` lines in main(), to change segments -- no build step.
#
# Layout: left-aligned segments, then rate limit + model/effort pushed
# flush right using $COLUMNS (falls back to 80 if unset).
#
# Requires: zsh, git, jq.
#
# Wire up in ~/.claude/settings.json:
#   { "statusLine": { "type": "command", "command": "~/.claude/statusline.zsh" } }

setopt extendedglob

# --- palette ---------------------------------------------------------------
readonly RESET=$'\e[0m'
readonly MODEL_FG=$'\e[38;2;96;96;121m'
readonly DIR_FG=$'\e[38;2;110;148;178m'
readonly BRANCH_FG=$'\e[38;2;96;96;121m'
readonly DIRTY_FG=$'\e[38;2;187;157;189m'
readonly SYNC_FG=$'\e[38;2;224;131;152m'
readonly ADD_FG=$'\e[38;2;96;96;121m'
readonly DEL_FG=$'\e[38;2;96;96;121m'
readonly CTX_FG=$'\e[38;2;243;190;124m'
readonly CACHE_FG=$'\e[38;2;127;165;99m'
readonly RATE_FG=$'\e[38;2;243;190;124m'
readonly COST_FG=$'\e[38;2;216;100;126m'

# Nerd-font context bar glyphs, empty (0) to full (7).
readonly -a CTX_BAR=("󰪞" "󰪟" "󰪠" "󰪡" "󰪢" "󰪣" "󰪤" "󰪥")

# Columns reserved at the right edge for Claude Code's own row chrome
# (padding, notification badges, verbose token counter) -- not reflected
# in $COLUMNS. Bump this up if the right cluster still gets clipped.
readonly -i RIGHT_MARGIN=3

# Strips SGR color codes so we can measure a segment's on-screen width.
strip_ansi() {
  print -r -- "${1//$'\e'\[[0-9;]#m/}"
}

# Parses `git status --porcelain=v2 --branch` output (passed in as $1).
# Prints "branch[*][ ⇣][⇡]", or nothing if not a repo.
git_segment() {
  local git_out=$1
  [[ -z "$git_out" ]] && return

  local branch="" dirty="" line
  local -i has_upstream=0 ahead=0 behind=0

  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    if [[ "$line" == '#'* ]]; then
      case "$line" in
      '# branch.head '*)
        branch=${line#'# branch.head '}
        [[ "$branch" == "(detached)" ]] && branch="DETACHED"
        ;;
      '# branch.upstream '*) has_upstream=1 ;;
      '# branch.ab '*)
        local ab=${line#'# branch.ab '}
        local a=${ab%% *} b=${ab##* }
        ahead=${a#+}
        behind=${b#-}
        ;;
      esac
    else
      # First non-header line means a tracked/untracked change exists.
      dirty=1
      break
    fi
  done <<<"$git_out"

  [[ -z "$branch" ]] && return

  local seg="${BRANCH_FG}${branch}${RESET}"
  [[ -n "$dirty" ]] && seg+="${DIRTY_FG}*${RESET}"
  if ((has_upstream && (ahead > 0 || behind > 0))); then
    seg+=" "
    ((behind > 0)) && seg+="${SYNC_FG}⇣${RESET}"
    ((ahead > 0)) && seg+="${SYNC_FG}⇡${RESET}"
  fi
  print -r -- "$seg"
}

# Parses the newline-separated `jj log` template output (passed in as $1):
# bookmark names, then change id. Prints "bookmark-or-change-id", or
# nothing if not a jj repo.
jj_segment() {
  local jj_out=$1
  [[ -z "$jj_out" ]] && return

  local -a lines=("${(@f)jj_out}")
  local bookmarks=$lines[1] change_id=$lines[2]
  [[ -z "$change_id" ]] && return

  local label=${bookmarks:-$change_id}
  print -r -- "${BRANCH_FG}${label}${RESET}"
}

# Last up-to-3 path components of $1, relative to $HOME, shrunk to fit
# within half the terminal width.
dir_segment() {
  local cwd=$1 rel=$1
  if [[ -n "$HOME" && "$cwd" == "$HOME"* ]]; then
    rel=${cwd#$HOME}
    rel=${rel#/}
  fi
  rel=${rel#/}

  local -a parts=("${(@s:/:)rel}")
  local -i n=${#parts} maxlen=$((${COLUMNS:-80} / 2))
  local -i keep=$((n < 3 ? n : 3))
  local dir=$rel
  while ((keep >= 1)); do
    dir="${(j:/:)parts[n-keep+1,n]}"
    ((${#dir} <= maxlen)) && break
    ((keep--))
  done
  print -r -- "${DIR_FG}${dir}${RESET}"
}

main() {
  local input=$(cat)

  # Run git (and jj, if installed) in the background so they overlap with
  # the jq parse below. The $+commands[] check is a hash-table lookup, not
  # a fork, so it's free even when jj isn't installed.
  local git_tmp="${TMPDIR:-/tmp}/cc_pure_git.$$"
  local jj_tmp="${TMPDIR:-/tmp}/cc_pure_jj.$$"
  trap 'rm -f "$git_tmp" "$jj_tmp"' EXIT
  { GIT_OPTIONAL_LOCKS=0 git status --porcelain=v2 --branch >"$git_tmp" 2>/dev/null; } &
  local git_pid=$!

  local jj_pid=0
  if (( $+commands[jj] )); then
    {
      jj log -r @ --no-graph --ignore-working-copy \
        -T 'bookmarks ++ "\n" ++ change_id.short(8) ++ "\n"' \
        >"$jj_tmp" 2>/dev/null
    } &
    jj_pid=$!
  fi

  # One jq fork, newline-separated fields into an array. No fallbacks for
  # missing used_percentage/cache counts -- assumes a recent Claude Code.
  local -a f=("${(@f)$(jq -r '
    .model.display_name,
    (.effort.level // ""),
    .workspace.current_dir,
    (.context_window.used_percentage // ""),
    (.context_window.current_usage.cache_read_input_tokens // 0),
    (.context_window.current_usage.cache_creation_input_tokens // 0),
    (.context_window.current_usage.input_tokens // 0),
    (.cost.total_cost_usd // ""),
    (.cost.total_lines_added // 0),
    (.cost.total_lines_removed // 0),
    (.rate_limits.five_hour.used_percentage // "")
  ' <<<"$input")}")

  local model=$f[1] effort=$f[2] cwd=$f[3] used_pct=$f[4]
  local -i cache_read=$f[5] cache_create=$f[6] fresh_input=$f[7]
  local cost=$f[8]
  local -i added=$f[9] removed=$f[10]
  local five_hour=$f[11]

  wait "$git_pid" 2>/dev/null
  local git_out=$(<"$git_tmp")

  local jj_out=""
  if ((jj_pid)); then
    wait "$jj_pid" 2>/dev/null
    jj_out=$(<"$jj_tmp")
  fi

  # --- left cluster: cwd, git, jj, changes, context usage, cache hit rate, cost
  local -a left=()

  left+="$(dir_segment "$cwd")"

  local git_seg=$(git_segment "$git_out")
  [[ -n "$git_seg" ]] && left+="$git_seg"

  local jj_seg=$(jj_segment "$jj_out")
  [[ -n "$jj_seg" ]] && left+="$jj_seg"

  ((added > 0)) && left+="${ADD_FG}+${added}${RESET}"
  ((removed > 0)) && left+="${DEL_FG}-${removed}${RESET}"

  if [[ -n "$used_pct" ]]; then
    local -i pct=${used_pct%%.*}
    local -i level=$(((pct * 8 + 50) / 100))
    ((level > 7)) && level=7
    left+="${CTX_FG}${CTX_BAR[level + 1]}${pct}%${RESET}"
  fi

  # % of cache-touched tokens that were cheap reads, not fresh writes.
  local -i cache_total=$((cache_read + cache_create + fresh_input))
  if ((cache_total > 0)); then
    local -i cache_pct=$(((cache_read * 100 + cache_total / 2) / cache_total))
    left+="${CACHE_FG}↻${cache_pct}%${RESET}"
  fi

  [[ -n "$cost" ]] && left+="${COST_FG}\$$(printf '%.2f' "$cost")${RESET}"

  # --- right cluster: rate limit, model/effort (model flush against the edge)
  local -a right=()

  [[ -n "$five_hour" ]] && right+="${RATE_FG}⏱${five_hour%%.*}%${RESET}"

  if [[ -n "$effort" ]]; then
    right+="${MODEL_FG}${model} (${effort})${RESET}"
  else
    right+="${MODEL_FG}${model}${RESET}"
  fi

  local left_joined="${(j: :)left}" right_joined="${(j: :)right}"
  local -i left_len="${#$(strip_ansi "$left_joined")}"
  local -i right_len="${#$(strip_ansi "$right_joined")}"

  local -i usable_cols=$((${COLUMNS:-80} - RIGHT_MARGIN))
  local -i pad=$((usable_cols - left_len - right_len - 1))
  ((pad < 1)) && pad=1

  local pad_str
  printf -v pad_str '%*s' "$pad" ''

  print -r -- "${left_joined}${pad_str}${right_joined}"
}

main
