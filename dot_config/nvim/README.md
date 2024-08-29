# My nvim config

My config is built on top of [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). 
I recommend trying it first before adding more plugins. `kickstart`'s `README` and `init.lua` 
do a great job of explaining how to configure `nvim`.

## Installation

- Install Neovim. A lot of plugins only support the latest version.
- Install `git`.
- Install a Nerd Font.
- Install `ripgrep` and all the languages you want to use (npm, go, ...).
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

The plugins I added can be found in `/lua/custom/plugins`. Some that stand out:

- `oil.nvim`. - file explorer with great interface.
- `flash.nvim`. - jump to any letter combination.
- `harpoon.nvim`. - fast switching between buffers.

Additionally, I added some `mini` plugins in `init.lua`: `mini.move`, `mini.starter`, `mini.bufremove`.

### Color Schemes

Aside from the usual `onedark`, I discovered a few other color schemes that I really enjoy.

- [Catppuccin](https://github.com/catppuccin/nvim) - has the best support across plugins and apps.
- [nordic.nvim](https://github.com/AlexvZyl/nordic.nvim) - a slightly darker Nord. This is currently my default.
- [monokai-pro.nvim](https://github.com/loctvl842/monokai-pro.nvim)
- [nightfox.nvim](https://github.com/EdenEast/nightfox.nvim) - specifically the `carbonfox` variant.

### AI

I am using `copilot.lua` and `CopilotChat` as coding assistants. While this is probably the weakest point of `nvim` at the moment,
I hope that they will be sufficient.

## Uninstalling

For information how to uninstall refer to the kickstart repository or go directly to [lazy.nvim](https://lazy.folke.io/usage#-uninstalling).

## Future Changes

- I am still figuring out what the optimal keybindings for `harpoon` are. They are currently under `j` for `jump`.
- I am going to change document symbols ` ds` and workspace symbols ` ws` somehow.
- I am currently trying `CopilotChat` for Cursor-like functionality. Other things to try:
    - gp.nvim
    - neocodeium
    - supermaven
- I might remove `neo-tree` again.
- I might add `neo-git`.
- I might add LSPs in the future.

## Things I wish I knew sooner

- The most impactful thing you can do is getting good at vim motions. All this setup is largely for fun.
- Read the [window docs](https://neovim.io/doc/user/windows.html) to understand what buffers and windows are.
- Run `:Lazy` to see what plugins you have installed. If something is broken, you might have to update your plugins.
- Run `:Mason` to permanently delete LSPs you installed.
- Commands (starting with `:`) can be autocompleted using `tab`.
- Explore the keymaps by pressing `space` and reading all the options.
- Select visual area, type `:` and then `s/<find>/<replace>/g` to replace text in a certain area.

