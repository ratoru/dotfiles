# My nvim config

My config is built on top of [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). 
I recommend trying it first before adding more plugins. `kickstart`'s `README` and `init.lua` 
do a great job of explaining how to configure `nvim`.

## Installation

- Install Neovim. A lot of plugins only support the latest version.
- Install `git`.
- Install a Nerd Font.
- Install all the languages you want to use (npm, go, ...).
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
- Smoother indentig.
- Smarter auto-continuation of comments.

### Plugins

The plugins I added can be found in `/lua/custom/plugins`. Some that stand out:

- `oil.nvim`. - file explorer with great interface.
- `leap.nvim`. - jump to any two letter combination.
- `harpoon.nvim`. - fast switching between buffers.

Additionally, I added some `mini` plugins in `init.lua`: `mini.move`, `mini.starter`, `mini.bufremove`.

### Color Schemes

Aside from the usual `onedark`, I discovered a few other color schemes that I really enjoy.

- [nordic.nvim](https://github.com/AlexvZyl/nordic.nvim) - a slightly darker Nord. This is currently my default.
- [monokai-pro.nvim](https://github.com/loctvl842/monokai-pro.nvim)
- [nightfox.nvim](https://github.com/EdenEast/nightfox.nvim) - specifically the `carbonfox` variant.

## Future Changes

- I am still figuring out what the optimal keybindings for `harpoon` are.
- I am still looking for AI code completion similar to Cursor.
- I have not added all the LSPs that I need.

