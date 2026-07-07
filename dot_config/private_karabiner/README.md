# Karabiner Elements Config

> [!NOTE]
> This config is for basic row-staggered keyboards. For my custom keybord I use [qmk](https://github.com/ratoru/qmk_userspace).

## @mxstbr's Karabiner Elements configuration

This repo is built upon mxstbr's [upstream repo](https://github.com/mxstbr/karabiner/).

If you like TypeScript and want your Karabiner configuration maintainable & type-safe, you probably want to use the custom configuration DSL / generator I created in `rules.ts` and `utils.ts`!

## My keymap

**Right Command** acts as the primary layer key, enabling access to various sublayers and direct mappings. **Caps Lock** is mapped to Left Control when held (with Escape on tap alone), and cancels an active sticky sublayer.

There are three kinds of bindings:

1. **Direct mappings**: Right Command + key triggers an immediate action (e.g. Right Command + J = Left Arrow).
2. **Sublayers**: Right Command + sublayer key, then a sub-key, while held (e.g. Right Command + W + F = maximize).
3. **Sticky sublayers**: Right Command + sublayer key latches a mode until the next key press.

See [`KEYMAP.md`](./KEYMAP.md) for the full keymap.

## Development

### Install

Make sure you have [Karabiner Elements](https://karabiner-elements.pqrs.org/) and `deno` installed. Then store your config in one of the following places.

- **Option 1**: Keep this config in `~/.config/karabiner/`.
- **Option 2**:
  - Install & start Karabiner Elements
  - Clone this repository
  - Delete the default ~/.config/karabiner folder
  - Create a symlink with `ln -s ~/github/mxstbr/karabiner ~/.config` (where `~/github/mxstbr/karabiner` is your local path to where you cloned the repository)
  - Restart karabiner_console_user_server with `launchctl kickstart -k gui/$(id -u)/org.pqrs.karabiner.karabiner_console_user_server`

### Commands

```bash
# Build config (generates karabiner.json)
deno task build

# Watch mode (rebuilds on changes)
deno task watch

# Regenerate the keymap doc (KEYMAP.md)
deno task docs

# Format code
deno fmt

# Lint code
deno lint
```

Edit `rules.ts`, run build, and your changes are live in Karabiner Elements.
