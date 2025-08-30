# Karabiner Elements Config

> [!NOTE]
> This config is for basic row-staggered keyboards. For my custom keybord I use [qmk](https://github.com/ratoru/qmk_userspace).

## @mxstbr's Karabiner Elements configuration

This repo is built upon mxstbr's [upstream repo](https://github.com/mxstbr/karabiner/).

If you like TypeScript and want your Karabiner configuration maintainable & type-safe, you probably want to use the custom configuration DSL / generator I created in `rules.ts` and `utils.ts`!

## My keymap

**Right Command** acts as the primary layer key, enabling access to various sublayers and direct mappings. **Caps Lock** is mapped to Left Control when held (with Escape on tap alone).

The system supports two types of layers:

1. **Direct mappings**: Right Command + key triggers immediate actions (e.g., Right Command + J = Left Arrow)
2. **Sticky sublayers**: Right Command + sublayer key activates a persistent mode until a final key is pressed

### Sticky Sublayers (persistent until final key pressed)

- `B` → Browse websites (A=Claude.ai, G=GitHub, R=Reddit, etc.)
- `G` → GitHub repositories (H=homepage, D=dotfiles, K=QMK userspace)
- `N` → Notes/Obsidian (A=add note, F=find notes, C=contact note, V=paste clipboard)
- `O` → Open applications (G=Chrome, T=Ghostty, V=Zed, etc.)
- `R` → Raycast extensions (C=color picker, E=emoji, P=confetti, H=clipboard history)

### Window Management Layer (`W`)

- `F` → Maximize, `G` → Almost maximize
- `H/J/K/L` → Left/Bottom/Top/Right half
- `M/,/.` → First/Center/Last third
- `Y/O` → Previous/Next display
- `U/I` → Previous/Next tab
- `N` → Next window
- `[/]` → Back/Forward

### System Controls Layer (`E`)

- `U/J` → Volume up/down
- `I/K` → Brightness up/down  
- `L` → Lock screen
- `P` → Play/pause
- `;` → Fast forward
- `V` → Voice command (Option+Space)
- `T` → Toggle system appearance (dark/light)

### Music Controls Layer (`C`)

- `P` → Play/pause
- `N` → Next track
- `B` → Previous track

### Direct Navigation Mappings (no sublayer)

- `J/K/I/L` → Left/Down/Up/Right arrows
- `H/Y` → Page down/up
- `;/P` → Backspace/Delete
- `F/D/S/A` → Shift/Cmd/Option/Control modifiers
- `M` → Magicmove (via homerow.app)
- `,` → Scroll mode (via homerow.app)

## Development

### Install

Make sure you have [Karabiner Elements](https://karabiner-elements.pqrs.org/) and `deno` installed. Then store your config in one of the following places.

- **Option 1**: Keep this config in `~/.config/karabiner/`.
- **Option 2**:
  - Install & start Karabiner Elements
  - Clone this repository
  - Delete the default ~/.config/karabiner folder
  - Create a symlink with ln -s ~/github/mxstbr/karabiner ~/.config (where ~/github/mxstbr/karabiner is your local path to where you cloned the repository)
  - Restart karabiner_console_user_server with launchctl kickstart -k gui/`id -u`/org.pqrs.karabiner.karabiner_console_user_server

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
