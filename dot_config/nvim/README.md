# My nvim config

My config is built on top of [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).
I recommend trying it first before adding more plugins. `kickstart`'s `README` and `init.lua`
do a great job of explaining how to configure `nvim`.

## Installation

- Install Neovim. A lot of plugins only support the latest version.
- Install `git`.
- Install a Nerd Font.
- Install `ripgrep`, `fzf`, `fd`, `tree-sitter-cli` and all the languages you want to use (npm, go, ...).
- Copy this folder into `~/.config/nvim/`. Alternatively, head over to [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
  and follow the install instructions.

### Post Installation

Start Neovim

```sh
nvim
```

That's it! Lazy will install all the plugins you have. Use `:Lazy` to view
current plugin status. Hit `q` to close the window.

Read through the `init.lua` file in your configuration folder for more
information about extending and exploring Neovim. That also includes
examples of adding popularly requested plugins.

## My Additions

### Settings and Keymaps

Read through `keymaps.lua` and `commands.lua` in `/lua/custom/` to see what I added. Some of the key features:

- Better clipboard handling.
- Smoother indenting.
- Smarter auto-continuation of comments.

### Plugins

The plugins I added can be found in `/lua/plugins`. Some that stand out:

- `oil.nvim`. - file explorer with great interface.
- `flash.nvim`. - jump to any letter combination.
- `grapple`. - fast switching between buffers.

Additionally, I added some `mini` plugins in `init.lua`.

### Color Schemes

My clear favorite is [tokyonight.nvim](https://github.com/folke/tokyonight.nvim).

I use [vague.nvim](https://github.com/vague-theme/vague.nvim) as my terminal theme, but couldn't
quite get used to it in Neovim. For the adventurous, here is a long list of noteworthy options:

- [Catppuccin](https://github.com/catppuccin/nvim)
- [gruvbox.nvim](https://github.com/ellisonleao/gruvbox.nvim)
- [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim)
- [monokai-pro.nvim](https://github.com/loctvl842/monokai-pro.nvim)
- [nightfox.nvim](https://github.com/EdenEast/nightfox.nvim) - specifically the `carbonfox` variant.
- [nordic.nvim](https://github.com/AlexvZyl/nordic.nvim) - a slightly darker Nord.
- [rose-pine](https://github.com/rose-pine/neovim)
- [tokyonight.nvim](https://github.com/folke/tokyonight.nvim)
- [vague.nvim](https://github.com/vague-theme/vague.nvim)
- [vim-moonfly-colors](https://github.com/bluz71/vim-moonfly-colors)

### AI

I usually run coding agents in their own terminal window. Inside nvim I mainly
rely on line completion and NEP using `copilot.lua` and `sidekick.nvim`.

On machines without AI access (e.g. no Copilot license), set `vim.g.ai_enabled
= false` in `init.lua`. This single flag disables `copilot.lua`,
`sidekick.nvim`, the `blink.cmp` copilot source, and the sidekick statusline
component.

## Uninstalling

For information how to uninstall refer to [lazy.nvim](https://lazy.folke.io/usage#-uninstalling).

## Things I wish I knew sooner

- The most impactful thing you can do is getting good at vim motions. All this setup is largely for fun.
- Take some time to read [LazyVim for Ambitious Devs](https://lazyvim-ambitious-devs.phillips.codes/course/chapter-1/) and [You don't grok Vi](https://stackoverflow.com/questions/1218390/what-is-your-most-productive-shortcut-with-vim/1220118#1220118).
- Read the [window docs](https://neovim.io/doc/user/windows.html) to understand what buffers and windows are.
- Run `:Lazy` to see what plugins you have installed. If something is broken, you might have to update your plugins.
- Run `:Mason` to permanently delete LSPs you installed.
- Commands (starting with `:`) can be autocompleted using `tab`.
- Explore the keymaps by pressing `space` and reading all the options.
- Select visual area, type `:` and then `s/<find>/<replace>/g` to replace text in a certain area.
- What the quickfix list is and how to use `cdo`.
- Use `P` in visual mode to paste without overwriting the register.
- `:[range]g/{pattern}/{command}` to run command on all lines matching pattern. `v` for lines not matching. Commands can be `d` (delete), `s` (substitute), `m` (move), `t` (copy), `normal` (normal mode commands), `j` (join), `y` (yank), etc.
- `q:` opens the command-line window: your command history in an editable buffer where you can navigate, edit and re-run with `<CR>`. `q/` and `q?` do the same for search history.
