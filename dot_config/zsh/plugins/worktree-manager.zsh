#!/usr/bin/env zsh
# Multi-project worktree manager with Claude support
#
# ASSUMPTIONS & SETUP:
# - Your git projects live in: ~/projects/
# - Worktrees will be created in: ~/projects/worktrees/<project>/<branch>
# - New branches will be named: <your-username>/<feature-name>
#
# DIRECTORY STRUCTURE EXAMPLE:
# ~/projects/
# ├── my-app/              (main git repo)
# ├── another-project/     (main git repo)
# └── worktrees/
#     ├── my-app/
#     │   ├── feature-x/   (worktree)
#     │   └── bugfix-y/    (worktree)
#     └── another-project/
#         └── new-feature/ (worktree)
#
# CUSTOMIZATION:
# To use different directories, modify these lines in the gw() function:
#   local projects_dir="$HOME/projects"
#   local worktrees_dir="$HOME/projects/worktrees"
#
# INSTALLATION:
# 1. Add to your .zshrc (in this order):
#    fpath=(~/.zsh/completions $fpath)
#    autoload -U compinit && compinit
#
# 2. Copy this entire script to your .zshrc (after the lines above)
#
# 3. Restart your terminal or run: source ~/.zshrc
#
# 4. Test it works: gw <TAB> should show your projects
#
# If tab completion doesn't work:
# - Make sure the fpath line comes BEFORE the gw function in your .zshrc
# - Restart your terminal completely
#
# USAGE:
#   gw <project> <worktree>              # cd to worktree (creates if needed)
#   gw <project> <worktree> <command>    # run command in worktree
#   gw --list                            # list all worktrees
#   gw --rm <project> <worktree>         # remove worktree
#
# EXAMPLES:
#   gw myapp feature-x                   # cd to feature-x worktree
#   gw myapp feature-x claude            # run claude in worktree

# Multi-project worktree manager
gw() {
    local projects_dir="$HOME/projects"
    local worktrees_dir="$HOME/projects/worktrees"

    # Helper function: Get git information for a worktree
    local _get_git_info() {
        local wt_path="$1"
        local info_type="$2"  # "basic", "detailed", or "stale-check"

        if [[ ! -d "$wt_path/.git" ]]; then
            return 1
        fi

        local current_branch last_commit status_output
        current_branch=$(cd "$wt_path" && git branch --show-current 2>/dev/null)

        case "$info_type" in
            "basic")
                if [[ -n "$current_branch" ]]; then
                    printf "(\\033[0;33m%s\\033[0m)" "$current_branch"
                fi
                if (cd "$wt_path" && git status --porcelain 2>/dev/null | grep -q .); then
                    printf " \\033[0;31m*\\033[0m"
                else
                    printf " \\033[0;32m✓\\033[0m"
                fi
                ;;
            "detailed")
                if [[ -n "$current_branch" ]]; then
                    echo "    Branch: \\033[0;33m$current_branch\\033[0m"
                fi

                last_commit=$(cd "$wt_path" && git log -1 --format="%h %s" 2>/dev/null)
                if [[ -n "$last_commit" ]]; then
                    echo "    Last commit: \\033[0;36m$last_commit\\033[0m"
                fi

                status_output=$(cd "$wt_path" && git status --porcelain 2>/dev/null)
                if [[ -n "$status_output" ]]; then
                    echo "    \\033[0;31mUncommitted changes:\\033[0m"
                    echo "$status_output" | head -5 | sed 's/^/      /'
                    local count=$(echo "$status_output" | wc -l)
                    if [[ $count -gt 5 ]]; then
                        echo "      ... and $((count - 5)) more files"
                    fi
                else
                    echo "    Status: \\033[0;32mClean\\033[0m"
                fi

                if [[ -n "$current_branch" ]] && git -C "$wt_path" rev-parse --verify "origin/$current_branch" >/dev/null 2>&1; then
                    local ahead_behind=$(cd "$wt_path" && git rev-list --left-right --count "origin/$current_branch...$current_branch" 2>/dev/null)
                    if [[ -n "$ahead_behind" ]]; then
                        local behind=$(echo "$ahead_behind" | cut -f1)
                        local ahead=$(echo "$ahead_behind" | cut -f2)
                        if [[ "$ahead" -gt 0 || "$behind" -gt 0 ]]; then
                            echo "    Remote: \\033[0;33m$ahead ahead, $behind behind\\033[0m"
                        else
                            echo "    Remote: \\033[0;32mUp to date\\033[0m"
                        fi
                    fi
                else
                    echo "    Remote: \\033[0;31mNo remote branch\\033[0m"
                fi
                ;;
            "stale-check")
                if [[ -z "$current_branch" ]]; then
                    return 1
                fi

                # Check if branch is merged to main/master
                local main_branch=""
                if git -C "$wt_path" show-ref --verify --quiet refs/remotes/origin/main; then
                    main_branch="origin/main"
                elif git -C "$wt_path" show-ref --verify --quiet refs/remotes/origin/master; then
                    main_branch="origin/master"
                fi

                if [[ -n "$main_branch" ]]; then
                    if git -C "$wt_path" merge-base --is-ancestor "$current_branch" "$main_branch" 2>/dev/null; then
                        echo "merged to $main_branch"
                        return 0
                    fi
                fi

                # Check if remote branch exists
                if ! git -C "$wt_path" rev-parse --verify "origin/$current_branch" >/dev/null 2>&1; then
                    if git -C "$wt_path" branch -r | grep -q "$current_branch"; then
                        echo "remote branch deleted"
                        return 0
                    fi
                fi

                return 1
                ;;
        esac
    }

    # Helper function: Process worktrees in both locations
    local _process_worktrees() {
        local action="$1"
        local found_any=false
        local cleanup_list=()

        # Process new location
        if [[ -d "$worktrees_dir" ]]; then
            for project in $worktrees_dir/*(/N); do
                found_any=true
                local project_name=$(basename "$project")

                case "$action" in
                    "list"|"status")
                        echo "\\n\\033[1;34m[$project_name]\\033[0m"
                        ;;
                esac

                for wt in $project/*(/N); do
                    local wt_name=$(basename "$wt")

                    case "$action" in
                        "list")
                            local git_info=$(_get_git_info "$wt" "basic")
                            echo "  • $wt_name $git_info"
                            ;;
                        "status")
                            echo "  \\033[1m$wt_name\\033[0m"
                            if [[ -d "$wt/.git" ]]; then
                                _get_git_info "$wt" "detailed"
                            else
                                echo "    \\033[0;31mNot a git repository\\033[0m"
                            fi
                            echo ""
                            ;;
                        "clean")
                            local reason=""
                            if [[ -d "$wt/.git" ]]; then
                                reason=$(_get_git_info "$wt" "stale-check")
                            else
                                reason="not a git repository"
                            fi

                            if [[ -n "$reason" ]]; then
                                found_any=true
                                echo "  \\033[0;33m[$project_name]\\033[0m $wt_name - \\033[0;31m$reason\\033[0m"
                                cleanup_list+=("$project_name:$wt_name:$wt")
                            fi
                            ;;
                    esac
                done
            done
        fi

        # Process legacy core-wts location
        if [[ -d "$projects_dir/core-wts" ]]; then
            found_any=true
            local project_name="core"

            case "$action" in
                "list"|"status")
                    echo "\\n\\033[1;34m[$project_name] (legacy location)\\033[0m"
                    ;;
            esac

            for wt in $projects_dir/core-wts/*(/N); do
                local wt_name=$(basename "$wt")

                case "$action" in
                    "list")
                        local git_info=$(_get_git_info "$wt" "basic")
                        echo "  • $wt_name $git_info"
                        ;;
                    "status")
                        echo "  \\033[1m$wt_name\\033[0m"
                        if [[ -d "$wt/.git" ]]; then
                            _get_git_info "$wt" "detailed"
                        else
                            echo "    \\033[0;31mNot a git repository\\033[0m"
                        fi
                        echo ""
                        ;;
                    "clean")
                        local reason=""
                        if [[ -d "$wt/.git" ]]; then
                            reason=$(_get_git_info "$wt" "stale-check")
                        else
                            reason="not a git repository"
                        fi

                        if [[ -n "$reason" ]]; then
                            echo "  \\033[0;33m[$project_name]\\033[0m $wt_name - \\033[0;31m$reason\\033[0m (legacy)"
                            cleanup_list+=("$project_name:$wt_name:$wt")
                        fi
                        ;;
                esac
            done
        fi

        # Return results based on action
        case "$action" in
            "list")
                if [[ "$found_any" == "false" ]]; then
                    echo "No worktrees found."
                else
                    echo "\\n\\033[0;90mLegend: \\033[0;32m✓\\033[0m = clean, \\033[0;31m*\\033[0m = uncommitted changes\\033[0m"
                fi
                ;;
            "status")
                if [[ "$found_any" == "false" ]]; then
                    echo "No worktrees found."
                fi
                ;;
            "clean")
                if [[ ${#cleanup_list[@]} -eq 0 ]]; then
                    echo "\\033[0;32mNo stale worktrees found.\\033[0m"
                    return 0
                fi

                echo "\\nFound ${#cleanup_list[@]} stale worktree(s)."
                echo "Remove them? [y/N]"
                read -r response
                if [[ "$response" =~ ^[Yy]$ ]]; then
                    for item in "${cleanup_list[@]}"; do
                        local project_name="${item%%:*}"
                        local rest="${item#*:}"
                        local wt_name="${rest%%:*}"
                        local wt_path="${rest#*:}"

                        echo "Removing $project_name/$wt_name..."
                        if [[ "$project_name" == "core" && "$wt_path" == *"core-wts"* ]]; then
                            (cd "$projects_dir/$project_name" && git worktree remove "$wt_path" 2>/dev/null || rm -rf "$wt_path")
                        else
                            (cd "$projects_dir/$project_name" && git worktree remove "$wt_path" 2>/dev/null || rm -rf "$wt_path")
                        fi
                    done
                    echo "\\033[0;32mCleanup completed.\\033[0m"
                else
                    echo "Cleanup cancelled."
                fi
                ;;
        esac
    }

    # Helper function: Find worktree path
    local _find_worktree_path() {
        local project="$1"
        local worktree="$2"

        if [[ "$project" == "core" ]]; then
            # For core, check old location first
            if [[ -d "$projects_dir/core-wts/$worktree" ]]; then
                echo "$projects_dir/core-wts/$worktree"
                return 0
            elif [[ -d "$worktrees_dir/$project/$worktree" ]]; then
                echo "$worktrees_dir/$project/$worktree"
                return 0
            fi
        else
            # For other projects, check new location
            if [[ -d "$worktrees_dir/$project/$worktree" ]]; then
                echo "$worktrees_dir/$project/$worktree"
                return 0
            fi
        fi

        return 1
    }

    # Helper function: Show help
    local _show_help() {
        echo "Multi-project worktree manager"
        echo ""
        echo "USAGE:"
        echo "  gw <project> <worktree>              # cd to worktree (creates if needed)"
        echo "  gw <project> <worktree> <command>    # run command in worktree (stays in current dir)"
        echo "  gw --list                            # list all worktrees"
        echo "  gw --status                          # show detailed worktree status"
        echo "  gw --clean                           # remove merged/stale worktrees"
        echo "  gw --rm <project> <worktree>         # remove specific worktree"
        echo "  gw --help, -h                       # show this help"
        echo ""
        echo "EXAMPLES:"
        echo "  gw myapp feature-x                   # cd to feature-x worktree"
        echo "  gw myapp feature-x claude            # run claude in worktree (no cd)"
    }

    # Helper function: Remove worktree
    local _remove_worktree() {
        local project="$2"
        local worktree="$3"

        if [[ -z "$project" || -z "$worktree" ]]; then
            echo "Usage: gw --rm <project> <worktree>"
            return 1
        fi

        local wt_path=$(_find_worktree_path "$project" "$worktree")
        if [[ -z "$wt_path" ]]; then
            echo "Worktree not found: $project/$worktree"
            return 1
        fi

        (cd "$projects_dir/$project" && git worktree remove "$wt_path")
        return $?
    }

    # Helper function: Create or navigate to worktree
    local _create_or_navigate() {
        local project="$1"
        local worktree="$2"
        shift 2
        local command=("$@")

        if [[ -z "$project" || -z "$worktree" ]]; then
            echo "Usage: gw <project> <worktree> [command...]"
            echo "       gw --list"
            echo "       gw --rm <project> <worktree>"
            return 1
        fi

        # Validate project name
        if [[ -z "$project" ]]; then
            echo "\\033[0;31mError: Project name cannot be empty\\033[0m"
            return 1
        fi

        # Check if project exists
        if [[ ! -d "$projects_dir/$project" ]]; then
            echo "\\033[0;31mError: Project not found: $projects_dir/$project\\033[0m"
            echo "Available projects:"
            for dir in $projects_dir/*(N/); do
                if [[ -d "$dir/.git" ]]; then
                    echo "  • $(basename "$dir")"
                fi
            done
            return 1
        fi

        # Check if project is a git repository
        if [[ ! -d "$projects_dir/$project/.git" ]]; then
            echo "\\033[0;31mError: $project is not a git repository\\033[0m"
            return 1
        fi

        # Find existing worktree or create new one
        local wt_path=$(_find_worktree_path "$project" "$worktree")

        if [[ -z "$wt_path" ]]; then
            # Validate worktree name
            if [[ -z "$worktree" ]]; then
                echo "\\033[0;31mError: Worktree name cannot be empty\\033[0m"
                return 1
            fi

            # Check for invalid characters in worktree name
            if [[ "$worktree" =~ [^a-zA-Z0-9._-] ]]; then
                echo "\\033[0;31mError: Worktree name contains invalid characters. Use only letters, numbers, dots, underscores, and hyphens.\\033[0m"
                return 1
            fi

            echo "Creating new worktree: \\033[0;33m$worktree\\033[0m"

            # Ensure worktrees directory exists
            if ! mkdir -p "$worktrees_dir/$project" 2>/dev/null; then
                echo "\\033[0;31mError: Failed to create worktrees directory: $worktrees_dir/$project\\033[0m"
                return 1
            fi

            # Determine branch name (use current username prefix)
            local branch_name="$USER/$worktree"

            # Check if branch already exists
            if (cd "$projects_dir/$project" && git show-ref --verify --quiet "refs/heads/$branch_name"); then
                echo "\\033[0;31mError: Branch '$branch_name' already exists\\033[0m"
                return 1
            fi

            # Create the worktree in new location
            wt_path="$worktrees_dir/$project/$worktree"
            (cd "$projects_dir/$project" && git worktree add "$wt_path" -b "$branch_name") || {
                echo "\\033[0;31mError: Failed to create worktree. Check git status and try again.\\033[0m"
                return 1
            }
            echo "\\033[0;32m✓ Created worktree: $worktree (branch: $branch_name)\\033[0m"
        fi

        # Execute based on number of arguments
        if [[ ${#command[@]} -eq 0 ]]; then
            # No command specified - just cd to the worktree
            cd "$wt_path"
        else
            # Command specified - run it in the worktree without cd'ing
            local old_pwd="$PWD"
            cd "$wt_path"
            eval "${command[@]}"
            local exit_code=$?
            cd "$old_pwd"
            return $exit_code
        fi
    }

    # Main command router
    case "$1" in
        --help|-h)
            _show_help
            ;;
        --list)
            echo "=== All Worktrees ==="
            _process_worktrees "list"
            ;;
        --status)
            echo "=== Detailed Worktree Status ==="
            _process_worktrees "status"
            ;;
        --clean)
            echo "=== Cleaning Stale Worktrees ==="
            _process_worktrees "clean"
            ;;
        --rm)
            _remove_worktree "$@"
            ;;
        *)
            _create_or_navigate "$@"
            ;;
    esac
}
