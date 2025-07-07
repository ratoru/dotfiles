import { KarabinerRules } from "./types.ts";
import {
  app,
  createSubLayers,
  mapTo,
  open,
  shell as _shell,
  window,
} from "./utils.ts";

const OBSIDIAN_VAULT = "1ca51b502102e7b3";

const rules: KarabinerRules[] = [
  // Define the Layer key itself
  {
    description: "Layer Key (Right Command)",
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
              name: "layer",
              value: 1,
            },
          },
        ],
        to_after_key_up: [
          {
            set_variable: {
              name: "layer",
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
    description: "MT(Escape, Left Control)",
    manipulators: [
      {
        description: "Caps Lock -> Left Control",
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
        type: "basic",
      },
    ],
  },

  ...createSubLayers({
    // Obsidian URIs need to be quoted since the URI format is non-standard.
    spacebar: open(
      `"obsidian://adv-uri?vault=${OBSIDIAN_VAULT}&commandid=zk-prefixer"`,
    ),
    // b = "B"rowse
    b: {
      c: open("https://claude.ai/new"),
      e: open("https://gmail.com"),
      g: open("https://github.com"),
      h: open("https://ratoru.com/blog"),
      l: open("https://leetcode.com/problemset/"),
      r: open("https://reddit.com"),
    },
    // o = "Open" applications
    o: {
      1: app("1Password"),
      b: app("Brave Browser"),
      c: app("Notion Calendar"),
      d: app("Discord"),
      e: app("Microsoft Outlook"),
      f: app("Finder"),
      // "i"Message
      i: app("Messages"),
      // "N"otes
      n: app("Obsidian"),
      p: app("Spotify"),
      s: app("Slack"),
      t: app("Ghostty"),
      v: app("Zed"),
      w: open("WhatsApp"),
      z: app("zoom.us"),
    },

    // w = "Window"
    w: {
      semicolon: mapTo("h", ["right_command"], "Window: Hide"),
      y: window("previous-display"),
      o: window("next-display"),
      k: window("top-half"),
      j: window("bottom-half"),
      h: window("left-half"),
      l: window("right-half"),
      f: window("maximize"),
      g: window("almost-maximize"),
      u: mapTo("tab", ["right_control", "right_shift"], "Window: Previous Tab"),
      i: mapTo("tab", ["right_control"], "Window: Next Tab"),
      n: mapTo(
        "grave_accent_and_tilde",
        ["right_command"],
        "Window: Next Window",
      ),
      b: mapTo("open_bracket", ["right_command"], "Window: Back"),
      // Note: No literal connection. Both f and n are already taken.
      m: mapTo("close_bracket", ["right_command"], "Window: Forward"),
    },

    // s = "System"
    s: {
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

    // a = "nAv" layer
    // A typical nav layer. Uses "a" so that sdf are comfortable modifiers.
    a: {
      h: mapTo("left_arrow"),
      j: mapTo("down_arrow"),
      k: mapTo("up_arrow"),
      l: mapTo("right_arrow"),
      u: mapTo("page_down"),
      i: mapTo("page_up"),
      semicolon: mapTo("delete_or_backspace"),
      p: mapTo("delete_forward"),
      f: mapTo("left_shift"),
      d: mapTo("left_command"),
      s: mapTo("left_option"),
      // Magicmove via homerow.app
      m: mapTo("f", ["right_control"]),
      // Scroll mode via homerow.app
      comma: mapTo("j", ["right_control"]),
    },

    // c = Musi*c* which isn't "m" because we want it to be on the left hand
    c: {
      p: mapTo("play_or_pause"),
      n: mapTo("fastforward"),
      b: mapTo("rewind"),
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
    v: mapTo("v", [
      "left_control",
      "left_shift",
      "left_option",
      "left_command",
    ]),
  }),
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
    },
  ],
};

await Deno.writeTextFile("karabiner.json", JSON.stringify(config, null, 2));
