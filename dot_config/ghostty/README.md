# Ghostty Config

This setups allows you to switch between different Ghostty configurations very easily.

## Switching Fonts and Themes

> [!NOTE]
> Credit to `pkazmier` and [this discussion](https://github.com/ghostty-org/ghostty/discussions/3527).

The contents of the configuration files in the directories `font` and `theme` contain small snippets of Ghostty configuration. (You could also make a directory for `opacity`.)

```
.
├── config
├── font
│   ├── iosevka-14
│   └── maple-mono
└── theme
    ├── catppuccin-mocha
    ├── default
    ├── gruvboxdark-hard
    └── tokyonight
```

With all the snippets defined, I then define the default for each grouping in my main Ghostty config file via the two config-file keys at the bottom:

```
config-file = font/maple-mono
config-file = theme/tokyonight
```

Now, I can use `fzf` to switch between different Ghostty configuration snippets. I added the following `ghosttyc` function (for Ghostty **C**onfig) to my `.zshrc`.

It uses `fd` to feed the list of snippets to fzf excluding the main Ghostty config file. Then, I bind an action to `fzf` and use the delimiter option to break apart the `dir/snippet` into fields `{1}` and `{2}` that I use in a `sed` statement to replace the correct config-file key in my main config.

Lastly, on a Mac, I can use the native integration of Ghostty to call AppleScript to reload my configuration.

```bash
function ghosttyc {
  local GHOSTTY_DIR="$HOME/.config/ghostty"
  local CMD="sed -i '' 's:\(config-file = {1}\)/.*:\1/{2}:' $GHOSTTY_DIR/config && osascript -so -e 'tell application \"Ghostty\" to activate' -e 'tell application \"System Events\" to keystroke \",\" using {command down, shift down}'"
  fd \
    --type f \
    --exclude 'config' \
    --exclude 'README.md' \
    --base-directory $GHOSTTY_DIR \
  | fzf \
    --style full \
    --layout=reverse \
    --list-label=" Settings " \
    --preview "bat --color=always --style=numbers -l INI $GHOSTTY_DIR/{}" \
    --preview-label=" Preview " \
    --delimiter=/ \
    --bind="enter:become:$CMD"
}
```

