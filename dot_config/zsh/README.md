# ZSH Config

> [!NOTE]
> Keep it simple and add only the things you need.

A fast shell in a few pieces:

- A plugin manager ([antidote](https://antidote.sh)) for community plugins, listed in `.zsh_plugins.txt`.
- An async prompt ([pure](https://github.com/sindresorhus/pure)) so git never stalls the prompt.
- A native syntax highlighter ([zsh-patina](https://github.com/michel-kraemer/zsh-patina)), activated last.
- Some options to configure history and completions.

Most of this evolved over time from a need to add aliases and shortcuts for things I do a lot.

This is a great guide to learn more about configuring `zsh`:
[Configuring zsh without dependencies](https://thevaluable.dev/zsh-install-configure-mouseless/)

## What do I need to install?

Via brew:

- [antidote](https://antidote.sh) — plugin manager.
- [zsh-patina](https://github.com/michel-kraemer/zsh-patina) — syntax highlighter (it's a binary, not a plugin).

Everything else (pure, autosuggestions, completions, history-substring-search, evalcache,
ez-compinit) is cloned by antidote from `.zsh_plugins.txt` on first start.

Tools like `mise`, `zoxide`, `fzf` and `jj` are initialized through
[evalcache](https://github.com/mroth/evalcache) so they don't fork a subprocess on every
startup. Run `_evalcache_clear` after upgrading them (wired into the `update` alias).

Files in the `plugins/` directory are vendored directly so they can't change without my knowledge.
