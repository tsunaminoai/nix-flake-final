{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.tsunaminoai.razer-mouse;
in {
  options.tsunaminoai.razer-mouse = {
    enable = mkEnableOption "Razer mouse desktop switcher";

    package = mkOption {
      type = types.enum [ "mac-mouse-fix" "karabiner-elements" ];
      default = "mac-mouse-fix";
      description = "The package to use for mouse button remapping";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = with pkgs; [
        (if cfg.package == "mac-mouse-fix" then mac-mouse-fix else karabiner-elements)
      ];
    }

    (mkIf (cfg.package == "mac-mouse-fix") {
      home.file.".config/mac-mouse-fix/config.json".text = builtins.toJSON {
        buttons = {
          "4" = {
            action = "keyPress";
            keys = [ "control" "left_arrow" ];
          };
          "5" = {
            action = "keyPress";
            keys = [ "control" "right_arrow" ];
          };
        };
      };
    })

    (mkIf (cfg.package == "karabiner-elements") {
      home.file.".config/karabiner/karabiner.json".text = builtins.toJSON {
        profiles = [{
          complex_modifications = {
            rules = [{
              description = "Mouse Side Buttons to Switch Desktops";
              manipulators = [
                {
                  type = "basic";
                  from = { pointing_button = "button4"; };
                  to = [{ key_code = "left_arrow"; modifiers = [ "control" ]; }];
                }
                {
                  type = "basic";
                  from = { pointing_button = "button5"; };
                  to = [{ key_code = "right_arrow"; modifiers = [ "control" ]; }];
                }
              ];
            }];
          };
        }];
      };
    })
  ]);
}