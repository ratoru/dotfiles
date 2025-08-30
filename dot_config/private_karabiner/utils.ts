import {
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
}

type LayerKeySublayer = {
  // The ? is necessary, otherwise we'd have to define something for _every_ key code
  [key_code in KeyCode]?: LayerCommand;
};

/**
 * Create a Layer Key sublayer, where every command is prefixed with a key
 * e.g. Layer + O ("Open") is the "open applications" layer, I can press
 * e.g. Layer + O + G ("Google Chrome") to open Chrome
 */
export function createLayerSubLayer(
  sublayer_key: KeyCode,
  commands: LayerKeySublayer,
  allSubLayerVariables: string[],
  layerVariableName: string = "layer",
): Manipulator[] {
  const subLayerVariableName = generateSubLayerVariableName(sublayer_key);

  return [
    // When Layer + sublayer_key is pressed, set the variable to 1; on key_up, set it to 0 again
    {
      description: `Toggle Layer sublayer ${sublayer_key}`,
      type: "basic",
      from: {
        key_code: sublayer_key,
        modifiers: {
          optional: ["any"],
        },
      },
      to_after_key_up: [
        {
          set_variable: {
            name: subLayerVariableName,
            // The default value of a variable is 0: https://karabiner-elements.pqrs.org/docs/json/complex-modifications-manipulator-definition/conditions/variable/
            // That means by using 0 and 1 we can filter for "0" in the conditions below and it'll work on startup
            value: 0,
          },
        },
      ],
      to: [
        {
          set_variable: {
            name: subLayerVariableName,
            value: 1,
          },
        },
      ],
      // This enables us to press other sublayer keys in the current sublayer
      // (e.g. Layer + O > M even though Layer + M is also a sublayer)
      // basically, only trigger a sublayer if no other sublayer is active
      conditions: [
        ...allSubLayerVariables
          .filter(
            (subLayerVariable) => subLayerVariable !== subLayerVariableName,
          )
          .map((subLayerVariable) => ({
            type: "variable_if" as const,
            name: subLayerVariable,
            value: 0,
          })),
        {
          type: "variable_if",
          name: layerVariableName,
          value: 1,
        },
      ],
    },
    // Define the individual commands that are meant to trigger in the sublayer
    ...(Object.keys(commands) as (keyof typeof commands)[]).map(
      (command_key): Manipulator => ({
        ...commands[command_key],
        type: "basic" as const,
        from: {
          key_code: command_key,
          modifiers: {
            optional: ["any"],
          },
        },
        // Only trigger this command if the variable is 1 (i.e., if Layer + sublayer is held)
        conditions: [
          {
            type: "variable_if",
            name: subLayerVariableName,
            value: 1,
          },
        ],
      }),
    ),
  ];
}

/**
 * Create all layer sublayers. This needs to be a single function, as well need to
 * have all the layer variable names in order to filter them and make sure only one
 * activates at a time
 */
export function createLayerSubLayers(
  subLayers: {
    [key_code in KeyCode]?: LayerKeySublayer | LayerCommand;
  },
  layerVariableName: string = "layer",
): KarabinerRules[] {
  const allSubLayerVariables = (
    Object.keys(subLayers) as (keyof typeof subLayers)[]
  ).map((sublayer_key) => generateSubLayerVariableName(sublayer_key));

  return Object.entries(subLayers).map(([key, value]) =>
    "to" in value
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
            ],
          },
        ],
      }
      : {
        description: `${getLayerKeyName(layerVariableName)} sublayer "${key}"`,
        manipulators: createLayerSubLayer(
          key as KeyCode,
          value,
          allSubLayerVariables,
          layerVariableName,
        ),
      }
  );
}

export function generateSubLayerVariableName(key: KeyCode) {
  return `layer_sublayer_${key}`;
}

function getLayerKeyName(layerVariableName: string): string {
  switch (layerVariableName) {
    case "action_layer":
      return "Action Layer";
    case "nav_layer":
      return "Navigation Layer";
    default:
      return "Layer Key";
  }
}

/**
 * Utility for creating basic remappings like "i -> ctrl + tab"
 */
export function mapTo(
  key_code: KeyCode,
  modifiers?: ModifiersKeys[],
  description?: string,
): LayerCommand {
  const key_config: LayerCommand = {
    to: [
      {
        key_code: key_code,
      },
    ],
  };
  if (typeof modifiers !== "undefined") {
    key_config["to"][0]["modifiers"] = modifiers;
  }
  if (typeof description !== "undefined") {
    key_config["description"] = description;
  }

  return key_config;
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
 * Shortcut for "Open an app" command (of which there are a bunch)
 */
export function app(name: string): LayerCommand {
  return open(`-a '${name}.app'`);
}

/**
 * Create a Sticky Layer Key sublayer, where the sublayer toggles on and stays active
 * until another key is pressed. For example, Layer + O toggles the "open applications"
 * layer which stays active until you press a mapped key (to execute) or unmapped key (to cancel).
 */
export function createStickyLayerSubLayer(
  sublayer_key: KeyCode,
  commands: LayerKeySublayer,
  allSubLayerVariables: string[],
  layerVariableName: string = "layer",
): Manipulator[] {
  const subLayerVariableName = generateSubLayerVariableName(sublayer_key);

  return [
    // When Layer + sublayer_key is pressed, toggle the sublayer variable
    {
      description: `Toggle Sticky Layer sublayer ${sublayer_key}`,
      type: "basic",
      from: {
        key_code: sublayer_key,
        modifiers: {
          optional: ["any"],
        },
      },
      to: [
        {
          set_variable: {
            name: subLayerVariableName,
            value: 1,
          },
        },
      ],
      conditions: [
        ...allSubLayerVariables
          .filter(
            (subLayerVariable) => subLayerVariable !== subLayerVariableName,
          )
          .map((subLayerVariable) => ({
            type: "variable_if" as const,
            name: subLayerVariable,
            value: 0,
          })),
        {
          type: "variable_if",
          name: layerVariableName,
          value: 1,
        },
        // Only activate if the sublayer is currently off
        {
          type: "variable_if",
          name: subLayerVariableName,
          value: 0,
        },
      ],
    },
    // Define the individual commands that trigger in the sublayer and deactivate it
    ...(Object.keys(commands) as (keyof typeof commands)[]).map(
      (command_key): Manipulator => ({
        ...commands[command_key],
        type: "basic" as const,
        from: {
          key_code: command_key,
          modifiers: {
            optional: ["any"],
          },
        },
        // Execute the command AND deactivate the sublayer
        to: [
          ...(commands[command_key]!.to || []),
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
      }),
    ),
    // Deactivate sublayer on any unmapped key press
    ...generateDeactivationRules(
      subLayerVariableName,
      Object.keys(commands) as KeyCode[],
    ),
  ];
}

/**
 * Create all sticky layer sublayers - similar to createLayerSubLayers but uses sticky behavior
 */
export function createStickyLayerSubLayers(
  subLayers: {
    [key_code in KeyCode]?: LayerKeySublayer | LayerCommand;
  },
  layerVariableName: string = "layer",
): KarabinerRules[] {
  const allSubLayerVariables = (
    Object.keys(subLayers) as (keyof typeof subLayers)[]
  ).map((sublayer_key) => generateSubLayerVariableName(sublayer_key));

  return Object.entries(subLayers).map(([key, value]) =>
    "to" in value
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
            ],
          },
        ],
      }
      : {
        description: `${
          getLayerKeyName(layerVariableName)
        } sticky sublayer "${key}"`,
        manipulators: createStickyLayerSubLayer(
          key as KeyCode,
          value,
          allSubLayerVariables,
          layerVariableName,
        ),
      }
  );
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
