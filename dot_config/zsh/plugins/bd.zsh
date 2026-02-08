#!/usr/bin/env zsh

bd() {
  # Ensure standard zsh behavior inside the function
  emulate -L zsh
  setopt extendedglob

  local target="$1"
  local current="$PWD"

  if [[ -z "$target" ]]; then
    printf -- 'usage: %s <name-of-any-parent-directory>\n' "bd"
    printf -- '       %s <number-of-folders>\n' "bd"
    return 1
  fi

  # If the user provided an integer, go up as many times as asked
  if [[ "$target" == <-> ]]; then
    local path_up=""
    local i
    # Estimate depth to prevent errors
    local num_parents=$(( ${(c)#current} - 1 ))

    if (( target > num_parents )); then
       printf -- '%s: Error: Can not go up %s times (not enough parent directories)\n' "bd" "$target" >&2
       return 1
    fi

    for ((i=0; i<target; i++)); do
      path_up+="../"
    done

    cd "$path_up" || return 1
    return 0
  fi

  # Remove the current directory since it isn't a parent
  current="${current:h}"

  # Walk up the tree checking for the target directory
  while [[ "$current" != "/" && "$current" != "." ]]; do
    if [[ "${current:t}" == "$target" ]]; then
      cd "$current" || return 1
      return 0
    fi
    current="${current:h}"
  done

  # Check root specifically
  if [[ "$target" == "/" ]]; then
    cd /
    return 0
  fi

  # If the above methods fail
  printf -- '%s: Error: No parent directory named "%s"\n' "bd" "$target" >&2
  return 1
}

() {
  local -a colors
  local dir_color='1;31' # hard-coded default in zsh/complist

  # check for defined zstyle
  if zstyle -a ':completion:*' list-colors colors && [[ "$#colors" -ne 0 ]]; then
    local zstyle_color="${colors[(r)di=*]#di=}"
    if [[ -n "$zstyle_color" ]]; then
      dir_color="$zstyle_color"
    fi
  else
    return
  fi

  zstyle ':completion:*:*:bd:*:directories' list-colors "=*=${dir_color}"
}
