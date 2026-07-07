import { KarabinerRules } from "./types.ts";
import {
  app,
  consumer,
  createLayerSubLayers,
  generateSubLayerVariableName,
  mapTo,
  open,
  shell as _shell,
  sticky,
  stickySubLayerKeys,
  SubLayers,
  window,
} from "./utils.ts";

const OBSIDIAN_VAULT = "303fb300701cd23b";

// Every Right Command (action layer) mapping lives in this single map. Direct
// mappings (e.g. j -> left arrow) sit next to sublayers (e.g. w -> Window). Wrap a
// sublayer in `sticky(...)` to make it latch on until the next key press; leave it
// unwrapped for hold-to-use. The caps-lock escape hatch below derives the list of
// sticky sublayers from this map automatically, so that is the only edit needed.
export const actionLayer: SubLayers = {
  // Obsidian URIs need to be quoted since the URI format is non-standard.
  spacebar: open(
    `"obsidian://adv-uri?vault=${OBSIDIAN_VAULT}&commandid=zk-prefixer"`,
  ),

  // w = "Window"
  w: {
    semicolon: mapTo("h", ["right_command"], "Window: Hide"),
    y: window("previous-display"),
    o: window("next-display"),
    u: mapTo("tab", ["right_control", "right_shift"], "Window: Previous Tab"),
    i: mapTo("tab", ["right_control"], "Window: Next Tab"),

    k: window("top-half"),
    j: window("bottom-half"),
    h: window("left-half"),
    l: window("right-half"),

    f: window("maximize"),
    g: window("almost-maximize"),

    n: mapTo(
      "grave_accent_and_tilde",
      ["right_command"],
      "Window: Next Window",
    ),
    open_bracket: mapTo("open_bracket", ["right_command"], "Window: Back"),
    // Note: No literal connection. Both f and n are already taken.
    close_bracket: mapTo(
      "close_bracket",
      ["right_command"],
      "Window: Forward",
    ),

    m: window("first-third"),
    comma: window("center-third"),
    period: window("last-third"),
  },

  // s = "System"
  e: {
    u: mapTo("volume_increment"),
    j: mapTo("volume_decrement"),
    i: mapTo("display_brightness_increment"),
    k: mapTo("display_brightness_decrement"),
    l: mapTo("q", ["right_control", "right_command"], "System: Lock Screen"),
    p: mapTo("play_or_pause"),
    semicolon: mapTo("fastforward"),
    // 'v'oice
    v: mapTo("spacebar", ["left_option"]),
    // "T"heme
    t: open(`raycast://extensions/raycast/system/toggle-system-appearance`),
    // "M"ic mute (v15.6 consumer key)
    m: consumer("microphone", "System: Mute Microphone"),
    // "D"o Not Disturb (v15.8 key)
    d: mapTo("do_not_disturb", undefined, "System: Do Not Disturb"),
  },

  // c = Musi*c* which isn't "m" because we want it to be on the left hand
  c: {
    p: consumer("play_or_pause", "Music: Play/Pause"),
    // scan_next/previous are true track-skip (fastforward/rewind only seek).
    n: consumer("scan_next_track", "Music: Next Track"),
    b: consumer("scan_previous_track", "Music: Previous Track"),
  },

  j: mapTo("left_arrow"),
  k: mapTo("down_arrow"),
  i: mapTo("up_arrow"),
  l: mapTo("right_arrow"),
  h: mapTo("page_down"),
  y: mapTo("page_up"),
  semicolon: mapTo("delete_or_backspace"),
  // p = "Presentify" (nested sublayer). Note: this replaces the old
  // delete_forward mapping that used to live on `p`.
  p: {
    a: mapTo(
      "a",
      ["left_control", "left_shift", "left_option"],
      "Presentify: Annotate Screen",
    ),
    d: mapTo(
      "d",
      ["left_control", "left_shift", "left_option"],
      "Presentify: Annotate Without Controls",
    ),
    f: mapTo(
      "h",
      ["left_control", "left_shift", "left_option"],
      "Presentify: Highlight Cursor",
    ),
    s: mapTo(
      "s",
      ["left_control", "left_shift", "left_option"],
      "Presentify: Spotlight Cursor",
    ),
  },
  f: mapTo("left_shift"),
  d: mapTo("left_command"),
  s: mapTo("left_option"),
  a: mapTo("left_control"),
  // Magicmove via homerow.app
  m: mapTo("m", ["right_control", "right_option", "right_shift"]),
  // Scroll mode via homerow.app
  comma: mapTo("comma", ["right_control", "right_option", "right_shift"]),

  v: mapTo("v", ["left_control", "left_option", "left_command", "left_shift"]),

  // --- Sticky sublayers ---
  // Tap Right Command + key to latch the mode on until the next key press.
  // Unwrap `sticky(...)` on any of these to make it hold-to-use instead.

  // b = "B"rowse
  b: sticky({
    c: open("https://calendar.google.com/calendar/u/0/r/week"),
    e: open("https://gmail.com"),
    g: open("https://github.com"),
    l: open("https://leetcode.com/problemset/"),
    t: open("https://monkeytype.com"),
  }),

  // g = "G"itHub
  g: sticky({
    h: open("https://github.com/ratoru/homepage"),
    d: open("https://github.com/ratoru/dotfiles"),
    k: open("https://github.com/ratoru/qmk_userspace"),
  }),

  // n = "Notes"
  n: sticky({
    // Add to unique note
    a: open(
      `"obsidian://adv-uri?vault=${OBSIDIAN_VAULT}&commandid=zk-prefixer"`,
    ),
    // Find notes
    f: open(
      `"obsidian://adv-uri?vault=${OBSIDIAN_VAULT}&commandid=switcher%3Aopen"`,
    ),
    // Open "C"ontact note
    c: open(
      `"obsidian://open?vault=${OBSIDIAN_VAULT}&file=Categories%2FPeople%23Contact%20today"`,
    ),
    // Paste clipboard into new note
    v: open(`"obsidian://new?vault=${OBSIDIAN_VAULT}&clipboard&append"`),
  }),

  // o = "Open" applications
  o: sticky({
    1: app("1Password"),
    a: app("Obsidian"),
    c: app("Calendar"),
    d: app("Linear"),
    e: app("Claude"),
    f: app("Brave Browser"),
    i: app("Messages"),
    m: app("Spotify"),
    n: app("Notion"),
    s: app("Slack"),
    t: app("Ghostty"),
    v: app("FaceTime"),
    w: app("WhatsApp"),
    z: app("zoom.us"),
  }),

  // r = "Raycast"
  r: sticky({
    c: open(
      "raycast://extensions/thomas/color-picker/pick-color?launchType=background",
    ),
    e: open(
      "raycast://extensions/raycast/emoji-symbols/search-emoji-symbols",
    ),
    p: open(
      "raycast://extensions/raycast/raycast/confetti?launchType=background",
    ),
    h: open(
      "raycast://extensions/raycast/clipboard-history/clipboard-history",
    ),
    1: open(
      "raycast://extensions/VladCuciureanu/toothpick/connect-favorite-device-1",
    ),
    2: open(
      "raycast://extensions/VladCuciureanu/toothpick/connect-favorite-device-2",
    ),
  }),
};

const rules: KarabinerRules[] = [
  // Define the Layer key itself
  {
    description: "Action Layer Key",
    manipulators: [
      {
        description: "Right Command -> Layer Key",
        from: {
          key_code: "right_command",
          modifiers: {
            optional: ["any"],
          },
        },
        to: [
          {
            set_variable: {
              name: "action_layer",
              value: 1,
            },
          },
        ],
        to_after_key_up: [
          {
            set_variable: {
              name: "action_layer",
              value: 0,
            },
          },
        ],
        to_if_alone: [
          {
            key_code: "escape",
          },
        ],
        type: "basic",
      },
    ],
  },
  {
    description: "Power Caps Lock",
    manipulators: [
      {
        description: "Tap -> Escape, Hold -> Left Control",
        from: {
          key_code: "caps_lock",
          modifiers: {
            optional: ["any"],
          },
        },
        to: [
          {
            key_code: "left_control",
          },
        ],
        to_if_alone: [
          {
            key_code: "escape",
          },
        ],
        conditions: [
          // Only allow caps lock -> control when sticky sublayers are inactive, so
          // caps lock can cancel an active sticky sublayer. Derived from whatever is
          // wrapped in `sticky(...)` in actionLayer, so there is nothing to keep in sync.
          ...stickySubLayerKeys(actionLayer).map((key) => ({
            type: "variable_if" as const,
            name: generateSubLayerVariableName(key),
            value: 0,
          })),
        ],
        type: "basic",
      },
    ],
  },

  ...createLayerSubLayers(actionLayer, "action_layer"),
];

const config = {
  global: {
    show_in_menu_bar: false,
    check_for_updates_on_startup: true,
  },
  profiles: [
    {
      name: "Default",
      complex_modifications: {
        rules,
      },
      virtual_hid_keyboard: {
        // I am building this for the US keyboard layout.
        keyboard_type_v2: "ansi",
      },
      devices: [
        {
          // Aurora Sweep rev1 (splitkb.com)
          identifiers: {
            is_keyboard: true,
            product_id: 60439,
            vendor_id: 36125,
          },
          ignore: true,
        },
        {
          // Kyria rev3 (splitkb.com)
          identifiers: {
            is_keyboard: true,
            product_id: 53060,
            vendor_id: 36125,
          },
          ignore: true,
        },
        {
          // Halcyon Elora rev2 (splitkb.com)
          identifiers: {
            is_keyboard: true,
            product_id: 41874,
            vendor_id: 36125,
          },
          ignore: true,
        },
      ],
    },
  ],
};

// Only write when run directly (so docs.ts can import `actionLayer` without a build
// side effect). Output path is configurable so the same script serves both the
// chezmoi source (private_karabiner.json, deployed as karabiner.json) and in-place.
if (import.meta.main) {
  const outFile = Deno.args[0] ?? "karabiner.json";
  await Deno.writeTextFile(outFile, JSON.stringify(config, null, 2) + "\n");
}
