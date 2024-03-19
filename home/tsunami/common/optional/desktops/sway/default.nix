{
  pkgs,
  lib,
  ...
}: {
  home.sessionVariables.WLR_RENDERER = lib.mkForce "gles2";
  wayland.windowManager.sway = {
    extraOptions = ["--unsupported-gpu"];
    enable = true;
    config = rec {
      modifier = "Mod4";
      # Use kitty as default terminal
      terminal = "alacritty";
      startup = [
        {command = "exec sleep 5; systemctl --user start kanshi.service";}
        # Launch Firefox on start
        # {command = "firefox";}
      ];
    };
  };
}
