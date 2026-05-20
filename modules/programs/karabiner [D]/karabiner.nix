{ inputs, ... }:
let
  # Apps where modifier remaps should NOT apply. Terminals need raw Ctrl for
  # SIGINT / readline, and raw Alt as Meta for word-jumps, tmux, emacs, etc.
  # Extend by adding the app's bundle identifier as a regex.
  terminalBundleIds = [
    "^com\\.mitchellh\\.ghostty$"
    "^com\\.googlecode\\.iterm2$"
  ];

  excludeTerminalsCondition = [
    {
      type = "frontmost_application_unless";
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

  # Ctrl→Cmd for clipboard / editing / app shortcuts. Excluded in terminals so
  # Ctrl+C remains SIGINT, Ctrl+R remains history search, etc.
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
      conditions = excludeTerminalsCondition;
    }
  ) ctrlRemappedKeys;

  # Option→Cmd for OS-level shortcuts (window/app switching). No terminal
  # exclusion — these are intercepted before any app sees them, matching how
  # Linux WMs handle Alt+Tab regardless of focused window.
  altOsLevelKeys = [
    "tab"
  ];

  altOsLevelManipulators = map (
    key:
    mkSwap {
      fromMod = "left_option";
      toMod = "left_command";
      inherit key;
    }
  ) altOsLevelKeys;

  # Option→Cmd for in-app shortcuts (e.g. browser back/forward). Excluded in
  # terminals so Option stays available as Meta for readline/tmux/emacs.
  # Empty by default — populate when you want specific Alt-based in-app
  # shortcuts (e.g. "left_arrow", "right_arrow" for browser nav).
  altInAppKeys = [ ];

  altInAppManipulators = map (
    key:
    mkSwap {
      fromMod = "left_option";
      toMod = "left_command";
      inherit key;
      conditions = excludeTerminalsCondition;
    }
  ) altInAppKeys;

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
              description = "Linux-style Ctrl shortcuts (Ctrl→Cmd outside terminals)";
              manipulators = ctrlToCmdManipulators;
            }
            {
              description = "Linux-style Alt shortcuts — OS-level (Option→Cmd, all apps)";
              manipulators = altOsLevelManipulators;
            }
            {
              description = "Linux-style Alt shortcuts — in-app (Option→Cmd outside terminals)";
              manipulators = altInAppManipulators;
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
