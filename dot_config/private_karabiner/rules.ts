import { KarabinerRules } from "./types.ts";
import {
  app,
  createLayerSubLayers,
  createStickyLayerSubLayers,
  generateSubLayerVariableName,
  mapTo,
  open,
  shell as _shell,
  window,
} from "./utils.ts";

const OBSIDIAN_VAULT = "1ca51b502102e7b3";

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
          // Only allow caps lock -> control when sticky sublayers are inactive
          // This ensures caps lock can cancel active sticky sublayers (o, n, r)
          // NOTE: If you add more sticky sublayers, add them here too.
          ...(["b", "g", "o", "n", "r"] as const).map((key) => ({
            type: "variable_if" as const,
            name: generateSubLayerVariableName(key),
            value: 0,
          })),
        ],
        type: "basic",
      },
    ],
  },

  ...createLayerSubLayers({
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
    },

    // c = Musi*c* which isn't "m" because we want it to be on the left hand
    c: {
      p: mapTo("play_or_pause"),
      n: mapTo("fastforward"),
      b: mapTo("rewind"),
    },

    j: mapTo("left_arrow"),
    k: mapTo("down_arrow"),
    i: mapTo("up_arrow"),
    l: mapTo("right_arrow"),
    h: mapTo("page_down"),
    y: mapTo("page_up"),
    semicolon: mapTo("delete_or_backspace"),
    p: mapTo("delete_forward"),
    f: mapTo("left_shift"),
    d: mapTo("left_command"),
    s: mapTo("left_option"),
    a: mapTo("left_control"),
    // Magicmove via homerow.app
    m: mapTo("m", ["right_control", "right_option", "right_shift"]),
    // Scroll mode via homerow.app
    comma: mapTo("comma", ["right_control", "right_option", "right_shift"]),
  }, "action_layer"),

  // Sticky sublayers: Tap Right Command + sublayer key to activate a persistent mode.
  // The sublayer remains active until you press a final key or deactivate it with Escape/Caps Lock.
  // Example: Right Command + O (tap and release) activates "Open" mode, then press G to open Chrome.
  ...createStickyLayerSubLayers({
    // b = "B"rowse
    b: {
      a: open("https://claude.ai/new"),
      c: open("https://calendar.google.com/calendar/u/0/r/week"),
      e: open("https://gmail.com"),
      g: open("https://github.com"),
      l: open("https://leetcode.com/problemset/"),
      r: open("https://reddit.com"),
      t: open("https://monkeytype.com"),
    },

    // g = "G"itHub
    g: {
      h: open("https://github.com/ratoru/homepage"),
      d: open("https://github.com/ratoru/dotfiles"),
      k: open("https://github.com/ratoru/qmk_userspace"),
    },

    // n = "Notes"
    n: {
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
    },

    // o = "Open" applications (sticky behavior)
    o: {
      1: app("1Password"),
      a: app("Obsidian"),
      b: app("Brave Browser"),
      c: app("Calendar"),
      d: app("Things3"),
      f: app("FaceTime"),
      g: app("Google Chrome"),
      i: app("Messages"),
      m: app("Spotify"),
      n: app("Notion"),
      p: app("Linear"),
      s: app("Slack"),
      t: app("Ghostty"),
      v: app("Zed"),
      w: app("WhatsApp"),
      z: app("zoom.us"),
    },

    // r = "Raycast"
    r: {
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
    },
  }, "action_layer"),
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
      ],
    },
  ],
};

await Deno.writeTextFile("karabiner.json", JSON.stringify(config, null, 2));
