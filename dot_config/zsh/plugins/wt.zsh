wt() {
    emulate -L zsh
    setopt err_return no_unset pipe_fail

    if [[ $# -eq 0 ]]; then
        if ! git rev-parse --git-dir >/dev/null 2>&1; then
            print -u2 -P "%F{red}Error:%f Not in a git repository or worktree."
            return 1
        fi

        local out
        out=$(git worktree list | fzf \
            --preview='git -C {1} log --oneline -n10 --color=always' \
            -1 -0 | awk '{print $1}')

        if [[ -n "$out" ]]; then
            cd "$out"
        fi
        return 0
    fi

    case "${1:-}" in
    clone)
        if [[ -z "${2:-}" ]]; then
            # print -u2 sends output to stderr, -P enables color syntax
            print -u2 -P "%F{yellow}Usage:%f wt clone <repository-url> [folder-name]"
            return 1
        fi

        local repo_url="$2"
        local folder_name="${3:-${repo_url:t:r}}"

        if [[ -d "$folder_name" ]]; then
            print -u2 -P "%F{red}Error:%f Directory '$folder_name' already exists."
            return 1
        fi

        mkdir -p "$folder_name"
        cd "$folder_name"

        # init+fetch, not `clone --bare`: a bare clone dumps every remote
        # branch into refs/heads, so they all show up as local branches.
        git init --bare --ref-format=reftable .bare
        git -C .bare remote add origin "$repo_url"
        git -C .bare config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
        git -C .bare config core.logallrefupdates true
        git -C .bare config worktree.useRelativePaths true

        git -C .bare fetch origin
        git -C .bare remote set-head origin --auto >/dev/null

        local default_branch=${$(git -C .bare symbolic-ref refs/remotes/origin/HEAD)#refs/remotes/origin/}

        if [[ -n "$default_branch" ]]; then
            # Set up the Worker Pool
            git -C .bare worktree add -b "$default_branch" "../$default_branch" "origin/$default_branch"

            git -C .bare worktree add -b alpha ../alpha "$default_branch"
            git -C .bare worktree add -b beta ../beta "$default_branch"
            git -C .bare worktree add -b gamma ../gamma "$default_branch"

            cd "$default_branch"
            print -P "%F{green}Success:%f Created worktrees: $default_branch, alpha, beta, gamma."
        else
            print -u2 -P "%F{yellow}Warning:%f Repository cloned, but could not determine default branch."
        fi
        ;;
    *)
        print -u2 -P "%F{yellow}Unknown command:%f $1"
        print -u2 -P "%F{yellow}Usage:%f wt clone <repository-url> [folder-name]"
        return 1
        ;;
    esac
}
