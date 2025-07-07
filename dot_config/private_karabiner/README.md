# Karabiner Elements Config

> [!NOTE]
> This config is for basic row-staggered keyboards. For my custom keybord I use [qmk](https://github.com/ratoru/qmk_userspace).

## @mxstbr's Karabiner Elements configuration

This repo is built upon mxstbr's [upstream repo](https://github.com/mxstbr/karabiner/).

If you like TypeScript and want your Karabiner configuration maintainable & type-safe, you probably want to use the custom configuration DSL / generator I created in `rules.ts` and `utils.ts`!

## My keymap

Caps Lock becomes a mod tap key. Tapping it sends Escape. Holding it acts as a layer key (referred to as "Hyper Key" in the code for historical reasons).

> [!IMPORTANT]
> Despite the naming throughout the codebase, this is **not** a true "Hyper Key" (⌃⌥⇧⌘). Instead, it implements a **layer key system** where Right Command switches between different keyboard layers without sending modifier keys.

The magic happens with **nested layers**: `Right Command + O` activates the "Open" layer, then `G` opens Google Chrome. So `Right Command + O + G` = open Chrome.

Key layers:

- `O` → Open apps (G=Chrome, T=Terminal, etc.)
- `W` → Window management (F=fullscreen, H=left half, etc.)
- `S` → System (U=volume up, L=lock screen, etc.)
- `B` → Browse websites (C=Leetcode, R=Reddit, etc.)
- `V` → Movement (H/J/K/L for vim-like arrows)

## Development

### Install

Make sure you have [Karabiner Elements](https://karabiner-elements.pqrs.org/) and `deno` installed. Then store your config in one of the following places.

- **Option 1**: Keep this config in `~/.config/karabiner/`.
- **Option 2**:
  - Install & start Karabiner Elements
  - Clone this repository
  - Delete the default `~/.config/karabiner` folder
  - Create a symlink with `ln -s ~/github/mxstbr/karabiner ~/.config` (where `~/github/mxstbr/karabiner` is your local path to where you cloned the repository)
  - Restart karabiner_console_user_server with `launchctl kickstart -k gui/`id -u`/org.pqrs.karabiner.karabiner_console_user_server`

### Commands

```bash
# Build config (generates karabiner.json)
deno task build

# Watch mode (rebuilds on changes)
deno task watch

# Format code
deno fmt

# Lint code
deno lint
```

Edit `rules.ts`, run build, and your changes are live in Karabiner Elements.
