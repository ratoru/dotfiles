import {
  Conditions,
  ConsumerKeyCode,
  KarabinerRules,
  KeyCode,
  Manipulator,
  ModifiersKeys,
  To,
} from "./types.ts";

/**
 * Custom way to describe a command in a layer
 */
export interface LayerCommand {
  to: To[];
  description?: string;
  /**
   * Extra conditions AND-ed onto this command's generated manipulator conditions.
   * Use `withConditions(...)` to attach them for context-aware bindings.
   */
  conditions?: Conditions[];
}

export type LayerKeySublayer = {
  // The ? is necessary, otherwise we'd have to define something for _every_ key code
  [key_code in KeyCode]?: LayerCommand;
};

/**
 * A sublayer wrapped in `sticky(...)`: it latches on when tapped and stays active
 * until the next key press, instead of the default hold-to-use behavior.
 */
export interface StickySubLayer {
  sticky: LayerKeySublayer;
}

/**
 * The value of a top-level layer key: a direct command, a hold-to-use sublayer, or
 * a sticky sublayer.
 */
export type SubLayers = {
  [key_code in KeyCode]?: LayerCommand | LayerKeySublayer | StickySubLayer;
};

/**
 * Build the manipulators for a single sublayer, e.g. Layer + O ("Open") so that
 * Layer + O + G opens Chrome. When `sticky`, the sublayer latches on when tapped and
 * stays active until the next key press; otherwise it is active only while held.
 */
function createSubLayer(
  sublayer_key: KeyCode,
  commands: LayerKeySublayer,
  allSubLayerVariables: string[],
  layerVariableName: string,
  sticky: boolean,
): Manipulator[] {
  const subLayerVariableName = generateSubLayerVariableName(sublayer_key);

  // Only trigger a sublayer if no *other* sublayer is currently active. This lets us
  // press other sublayer keys inside a sublayer (e.g. Layer + O > M).
  const otherSublayersInactive = allSubLayerVariables
    .filter((subLayerVariable) => subLayerVariable !== subLayerVariableName)
    .map((subLayerVariable) => ({
      type: "variable_if" as const,
      name: subLayerVariable,
      value: 0,
    }));

  // Toggle the sublayer on. Hold-to-use resets on key up; sticky stays on until a
  // command runs or an unmapped key cancels it, and only re-latches when off.
  const toggle: Manipulator = {
    description: `Toggle ${
      sticky ? "Sticky " : ""
    }Layer sublayer ${sublayer_key}`,
    type: "basic",
    from: {
      key_code: sublayer_key,
      modifiers: { optional: ["any"] },
    },
    ...(sticky ? {} : {
      to_after_key_up: [
        { set_variable: { name: subLayerVariableName, value: 0 } },
      ],
    }),
    to: [{ set_variable: { name: subLayerVariableName, value: 1 } }],
    conditions: [
      ...otherSublayersInactive,
      { type: "variable_if", name: layerVariableName, value: 1 },
      ...(sticky
        ? [{
          type: "variable_if" as const,
          name: subLayerVariableName,
          value: 0,
        }]
        : []),
    ],
  };

  // One manipulator per command key, active only while the sublayer is on. Sticky
  // commands additionally switch the sublayer back off after firing.
  const commandManipulators = (Object.keys(commands) as KeyCode[]).map(
    (command_key): Manipulator => ({
      ...commands[command_key],
      type: "basic" as const,
      from: {
        key_code: command_key,
        modifiers: { optional: ["any"] },
      },
      ...(sticky
        ? {
          to: [
            ...(commands[command_key]!.to || []),
            { set_variable: { name: subLayerVariableName, value: 0 } },
          ],
        }
        : {}),
      conditions: [
        { type: "variable_if", name: subLayerVariableName, value: 1 },
        ...(commands[command_key]!.conditions ?? []),
      ],
    }),
  );

  return [
    toggle,
    ...commandManipulators,
    // Sticky sublayers also cancel themselves on any unmapped "escape" key.
    ...(sticky
      ? generateDeactivationRules(
        subLayerVariableName,
        Object.keys(commands) as KeyCode[],
      )
      : []),
  ];
}

/**
 * Flip a sublayer to "sticky" behavior: tap Layer + sublayer key to latch it on,
 * then it stays active until the next key press (a mapped key runs its command, an
 * unmapped key just cancels). Leave a sublayer unwrapped for the default hold-to-use
 * behavior. Wrapping / unwrapping with `sticky(...)` is the ONLY change needed to
 * switch a sublayer between the two modes.
 */
export function sticky(commands: LayerKeySublayer): StickySubLayer {
  return { sticky: commands };
}

function isStickyLayer(
  value: LayerCommand | LayerKeySublayer | StickySubLayer,
): value is StickySubLayer {
  return "sticky" in value;
}

function isLayerCommand(
  value: LayerCommand | LayerKeySublayer,
): value is LayerCommand {
  return "to" in value;
}

/**
 * The sublayer keys currently wrapped in `sticky(...)`. Use this to build the
 * caps-lock escape hatch so it stays in sync automatically.
 */
export function stickySubLayerKeys(subLayers: SubLayers): KeyCode[] {
  return (Object.keys(subLayers) as KeyCode[]).filter((key) =>
    isStickyLayer(subLayers[key]!)
  );
}

/**
 * Create all layer sublayers. Sublayers wrapped in `sticky(...)` get sticky
 * behavior; the rest are hold-to-use. Each mode is built as its own group so that,
 * within a group, only one sublayer can be active at a time.
 */
export function createLayerSubLayers(
  subLayers: SubLayers,
  layerVariableName: string = "layer",
): KarabinerRules[] {
  type Group = { [key_code in KeyCode]?: LayerCommand | LayerKeySublayer };
  const nonSticky: Group = {};
  const stickyLayers: Group = {};
  for (const [key, value] of Object.entries(subLayers)) {
    if (isStickyLayer(value)) {
      stickyLayers[key as KeyCode] = value.sticky;
    } else {
      nonSticky[key as KeyCode] = value;
    }
  }

  return [
    ...buildSubLayers(nonSticky, layerVariableName, false),
    ...buildSubLayers(stickyLayers, layerVariableName, true),
  ];
}

/**
 * Shared builder for one group of sublayers. `sticky` selects sticky vs. hold-to-use
 * behavior for each nested sublayer. All sublayer variables in the group are threaded
 * through so only one activates at a time.
 */
function buildSubLayers(
  subLayers: { [key_code in KeyCode]?: LayerCommand | LayerKeySublayer },
  layerVariableName: string,
  sticky: boolean,
): KarabinerRules[] {
  const allSubLayerVariables = (Object.keys(subLayers) as KeyCode[]).map(
    (sublayer_key) => generateSubLayerVariableName(sublayer_key),
  );

  return Object.entries(subLayers).map(([key, value]) =>
    isLayerCommand(value)
      ? {
        description: `${getLayerKeyName(layerVariableName)} + ${key}`,
        manipulators: [
          {
            ...value,
            type: "basic" as const,
            from: {
              key_code: key as KeyCode,
              modifiers: {
                optional: ["any"],
              },
            },
            conditions: [
              {
                type: "variable_if",
                name: layerVariableName,
                value: 1,
              },
              ...allSubLayerVariables.map((subLayerVariable) => ({
                type: "variable_if" as const,
                name: subLayerVariable,
                value: 0,
              })),
              ...(value.conditions ?? []),
            ],
          },
        ],
      }
      : {
        description: sticky
          ? `${getLayerKeyName(layerVariableName)} sticky sublayer "${key}"`
          : `${getLayerKeyName(layerVariableName)} sublayer "${key}"`,
        manipulators: createSubLayer(
          key as KeyCode,
          value,
          allSubLayerVariables,
          layerVariableName,
          sticky,
        ),
      }
  );
}

export function generateSubLayerVariableName(key: KeyCode) {
  return `layer_sublayer_${key}`;
}

function getLayerKeyName(layerVariableName: string): string {
  return layerVariableName === "action_layer" ? "Action Layer" : "Layer Key";
}

/**
 * Utility for creating basic remappings like "i -> ctrl + tab"
 */
export function mapTo(
  key_code: KeyCode,
  modifiers?: ModifiersKeys[],
  description?: string,
): LayerCommand {
  return {
    to: [{ key_code, ...(modifiers !== undefined && { modifiers }) }],
    ...(description !== undefined && { description }),
  };
}

/**
 * Send a consumer (media / system) usage key, e.g. scan_next_track or microphone.
 * Prefer this over the legacy `key_code` media aliases.
 */
export function consumer(
  consumer_key_code: ConsumerKeyCode,
  description?: string,
): LayerCommand {
  return {
    to: [{ consumer_key_code }],
    ...(description !== undefined && { description }),
  };
}

/**
 * Shortcut for "open" shell command
 */
export function open(...what: string[]): LayerCommand {
  return {
    to: what.map((w) => ({
      shell_command: `open ${w}`,
    })),
    description: `Open ${what.join(" & ")}`,
  };
}

/**
 * Utility function to create a LayerCommand from a tagged template literal
 * where each line is a shell command to be executed.
 */
export function shell(
  strings: TemplateStringsArray,
  ...values: unknown[]
): LayerCommand {
  const commands = strings.reduce((acc, str, i) => {
    const value = i < values.length ? values[i] : "";
    const lines = (str + value)
      .split("\n")
      .filter((line) => line.trim() !== "");
    acc.push(...lines);
    return acc;
  }, [] as string[]);

  return {
    to: commands.map((command) => ({
      shell_command: command.trim(),
    })),
    description: commands.join(" && "),
  };
}

/**
 * Shortcut for managing window sizing
 */
export function window(name: string): LayerCommand {
  return {
    to: [
      {
        // shell_command: `open -g rectangle://execute-action?name=${name}`,
        shell_command:
          `open -g raycast://extensions/raycast/window-management/${name}`,
      },
    ],
    description: `Window: ${name}`,
  };
}

/**
 * Open/activate an app by name via `open -a`, which resolves the app through Launch
 * Services (so it works regardless of whether it lives in /Applications or
 * /System/Applications). For a shell-free native launch, use `appById` instead.
 */
export function app(name: string): LayerCommand {
  return open(`-a '${name}.app'`);
}

/**
 * Open/activate an app natively (no shell) by bundle identifier, path-independent,
 * e.g. "com.apple.Safari". Prefer this over `app` when you have the bundle id.
 */
export function appById(
  bundle_identifier: string,
  name?: string,
): LayerCommand {
  return {
    to: [{ software_function: { open_application: { bundle_identifier } } }],
    description: `Open ${name ?? bundle_identifier}`,
  };
}

/**
 * Switch to a recent app via the frontmost-application history (1 = previous app).
 */
export function previousApp(index = 1): LayerCommand {
  return {
    to: [{
      software_function: {
        open_application: { frontmost_application_history_index: index },
      },
    }],
    description: `Switch to previous app (${index})`,
  };
}

/**
 * Attach extra conditions to a command so it only fires in a given context.
 * e.g. withConditions(mapTo("s", ["left_command"]), focusedRoleIs("AXTextArea")).
 */
export function withConditions(
  cmd: LayerCommand,
  ...conditions: Conditions[]
): LayerCommand {
  return { ...cmd, conditions: [...(cmd.conditions ?? []), ...conditions] };
}

/**
 * Condition: the accessibility role of the focused UI element equals `role`
 * (e.g. "AXTextArea", "AXTextField"). Requires Accessibility permission (v16.0).
 */
export function focusedRoleIs(role: string): Conditions {
  return {
    type: "variable_if",
    name: "accessibility.focused_ui_element.role_string",
    value: role,
  };
}

/**
 * Condition: one of the given app bundle identifiers is frontmost.
 */
export function frontmostAppIs(...bundle_identifiers: string[]): Conditions {
  return { type: "frontmost_application_if", bundle_identifiers };
}

/**
 * Generate rules to deactivate a sticky sublayer when unmapped keys are pressed
 */
function generateDeactivationRules(
  subLayerVariableName: string,
  mappedKeys: KeyCode[],
): Manipulator[] {
  // Keys that should deactivate the layer if not mapped
  const cancelKeys: KeyCode[] = [
    "spacebar",
    "escape",
    "caps_lock",
    "tab",
    "delete_or_backspace",
    "up_arrow",
    "down_arrow",
    "left_arrow",
    "right_arrow",
    "return_or_enter",
  ];

  // Only create deactivation rules for keys that aren't mapped in this sublayer
  const unmappedKeys = cancelKeys.filter((key) => !mappedKeys.includes(key));

  return unmappedKeys.map((key): Manipulator => ({
    description: `Deactivate sticky sublayer on unmapped key: ${key}`,
    type: "basic",
    from: {
      key_code: key,
      modifiers: {
        optional: ["any"],
      },
    },
    to: [
      // Only deactivate the sublayer, don't send the key again to avoid conflicts with MT behavior
      {
        set_variable: {
          name: subLayerVariableName,
          value: 0,
        },
      },
    ],
    conditions: [
      {
        type: "variable_if",
        name: subLayerVariableName,
        value: 1,
      },
    ],
  }));
}
