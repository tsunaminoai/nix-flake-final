{pkgs, ...}: {
  wayland.windowManager.sway = {
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
