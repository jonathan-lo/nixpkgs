{ inputs, ... }:
let
  # Apps where modifier remaps should NOT apply. Terminals need raw Ctrl for
  # SIGINT / readline, and raw Alt as Meta for word-jumps/tmux/emacs.
  # JetBrains IDEs ship a deep Ctrl-based keymap (Ctrl+Shift+A actions,
  # debugger, etc.) that should stay intact. Extend by adding bundle
  # identifier regexes.
  terminalBundleIds = [
    "^com\\.mitchellh\\.ghostty$"
    "^com\\.googlecode\\.iterm2$"
  ];

  excludedBundleIds = terminalBundleIds ++ [
    "^com\\.jetbrains\\."
  ];

  excludeAppsCondition = [
    {
      type = "frontmost_application_unless";
      bundle_identifiers = excludedBundleIds;
    }
  ];

  terminalOnlyCondition = [
    {
      type = "frontmost_application_if";
      bundle_identifiers = terminalBundleIds;
    }
  ];

  # `mandatory: [fromMod]` with `optional: [any]` carries through additional
  # modifiers (e.g. Shift), so Ctrl+Shift+T → Cmd+Shift+T from one manipulator.
  mkSwap =
    {
      fromMod,
      toMod,
      key,
      conditions ? null,
    }:
    let
      base = {
        type = "basic";
        from = {
          key_code = key;
          modifiers = {
            mandatory = [ fromMod ];
            optional = [ "any" ];
          };
        };
        to = [
          {
            key_code = key;
            modifiers = [ toMod ];
          }
        ];
      };
    in
    if conditions == null then base else base // { inherit conditions; };

  # Ctrl→Cmd for clipboard / editing / app shortcuts. Excluded in apps that
  # depend on raw Ctrl (terminals for SIGINT/readline, JetBrains IDEs for
  # their Ctrl-based keymap).
  ctrlRemappedKeys = [
    "a"
    "b"
    "c"
    "d"
    "e"
    "f"
    "g"
    "h"
    "i"
    "j"
    "k"
    "l"
    "m"
    "n"
    "o"
    "p"
    "q"
    "r"
    "s"
    "t"
    "u"
    "v"
    "w"
    "x"
    "y"
    "z"
  ];

  ctrlToCmdManipulators = map (
    key:
    mkSwap {
      fromMod = "left_control";
      toMod = "left_command";
      inherit key;
      conditions = excludeAppsCondition;
    }
  ) ctrlRemappedKeys;

  # Ctrl+Shift+{C,V,X} → Cmd+{C,V,X} inside terminals only. Matches the
  # GNOME/KDE convention where raw Ctrl+C stays as SIGINT.
  terminalCopyPasteManipulators =
    map
      (key: {
        type = "basic";
        from = {
          key_code = key;
          modifiers.mandatory = [
            "left_control"
            "left_shift"
          ];
        };
        to = [
          {
            key_code = key;
            modifiers = [ "left_command" ];
          }
        ];
        conditions = terminalOnlyCondition;
      })
      [
        "c"
        "v"
        "x"
      ];

  # Match every keyboard that isn't the laptop's built-in one. Covers any
  # external keyboard without enumerating vendor/product IDs.
  externalKeyboardCondition = [
    {
      type = "device_unless";
      identifiers = [ { is_built_in_keyboard = true; } ];
    }
  ];

  mkModSwap = from: to: {
    type = "basic";
    from = {
      key_code = from;
      modifiers.optional = [ "any" ];
    };
    to = [ { key_code = to; } ];
    conditions = externalKeyboardCondition;
  };

  optCmdSwapManipulators = [
    (mkModSwap "left_option" "left_command")
    (mkModSwap "left_command" "left_option")
    (mkModSwap "right_option" "right_command")
    (mkModSwap "right_command" "right_option")
  ];

  karabinerConfig = {
    global = {
      check_for_updates_on_startup = true;
      show_in_menu_bar = true;
      show_profile_name_in_menu_bar = false;
    };
    profiles = [
      {
        name = "Default";
        selected = true;
        complex_modifications = {
          parameters = {
            "basic.simultaneous_threshold_milliseconds" = 50;
            "basic.to_delayed_action_delay_milliseconds" = 500;
            "basic.to_if_alone_timeout_milliseconds" = 1000;
            "basic.to_if_held_down_threshold_milliseconds" = 500;
          };
          rules = [
            {
              description = "Swap Option ↔ Command on external keyboards";
              manipulators = optCmdSwapManipulators;
            }
            {
              description = "Linux-style Ctrl shortcuts (Ctrl→Cmd outside terminals)";
              manipulators = ctrlToCmdManipulators;
            }
            {
              description = "Linux-style copy/paste/cut in terminals (Ctrl+Shift+C/V/X → Cmd+C/V/X)";
              manipulators = terminalCopyPasteManipulators;
            }
          ];
        };
        virtual_hid_keyboard = {
          keyboard_type_v2 = "ansi";
        };
      }
    ];
  };
in
{
  flake.modules.darwin.karabiner = {
    homebrew.casks = [ "karabiner-elements" ];

    home-manager.sharedModules = [
      inputs.self.modules.homeManager.karabiner
    ];
  };

  flake.modules.homeManager.karabiner = {
    xdg.configFile."karabiner/karabiner.json".text = builtins.toJSON karabinerConfig;
  };
}
