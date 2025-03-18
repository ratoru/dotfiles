# ZSH Config

> [!NOTE]
> Keep it simple and add only the things you need.
> Most likely, you do not need a plugin manager.

You can get a wondeful shell in just a few steps:

- Install a prompt like `starship` or `pure`.
- Enable some of the most popular zsh plugins: Syntax highlighting and Autosuggestions.
- Set some options to configure history and completions.

Most of this configuration evolved over time from a need to add more aliases and shortcuts for
things I do a lot.

This is a great guide to learn more about how to configure `zsh`:
[Configuring zsh without dependencies](https://thevaluable.dev/zsh-install-configure-mouseless/)

## What do I need to install?

Things to install via brew:

- [zsh-autosuggesitons](https://github.com/zsh-users/zsh-autosuggestions)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [zsh-completions](https://github.com/zsh-users/zsh-completions)

Files in the `plugin/` directory could also be installed via homebrew or a package manager.
I decided to include them directly, so that I can be sure they won't change wihtout my knowledge.
