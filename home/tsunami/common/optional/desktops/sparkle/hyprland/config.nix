{
  config,
  theme,
  lib,
  ...
}: let
  pointer = config.home.pointerCursor;
in {
  wayland.windowManager.hyprland = with theme.colors; {
    settings = {
      exec-once = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        # set cursor for HL itself
        "hyprctl setcursor ${pointer.name} ${toString pointer.size}"
      ];
      monitor = [
        ",highrr,auto,1"
        "DP-2, preferred, auto, auto #right monitor"
        "DP-3, preferred, 0x0, auto #pins to the left"
      ];
      master = {
        new_is_master = true;
      };
      xwayland = {
        force_zero_scaling = true;
      };
      input = {
        # keyboard layout
        kb_layout = "us";
        kb_options = "caps:escape";
        follow_mouse = 1;
        sensitivity = 0.0;
        touchpad = {
          natural_scroll = false;
          clickfinger_behavior = true;
          tap-to-click = true;
          scroll_factor = 0.5;
        };
      };
      animations = {
        enabled = true;
        first_launch_animation = true;

        bezier = [
          "smoothOut, 0.36, 0, 0.66, -0.56"
          "smoothIn, 0.25, 1, 0.5, 1"
          "overshot, 0.4,0.8,0.2,1.2"
        ];
        animation = [
          "windows, 1, 4, overshot, slide"
          "windowsOut, 1, 4, smoothOut, slide"
          "border,1,10,default"

          "fade, 1, 10, smoothIn"
          "fadeDim, 1, 10, smoothIn"
          "workspaces,1,4,overshot,slidevert"
        ];
      };
      misc = {
        # disable redundant renders
        disable_splash_rendering = true;
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;

        vfr = true;

        # window swallowing
        enable_swallow = true; # hide windows that spawn other windows
        swallow_regex = "^(foot)$";

        # dpms
        mouse_move_enables_dpms = true; # enable dpms on mouse/touchpad action
        key_press_enables_dpms = true; # enable dpms on keyboard action
        disable_autoreload = true; # autoreload is unnecessary on nixos, because the config is readonly anyway
      };
      "$kw" = "dwindle:no_gaps_when_only";

      dwindle = {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = false; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # you probably want this
        no_gaps_when_only = false;
      };
      workspace = [
        "1, monitor:DP-2"
        "2, monitor:DP-2"
        "3, monitor:DP-2"
        "4, monitor:DP-2"
        "5, monitor:DP-3"
        "6, monitor:DP-3"
        "7, monitor:DP-3"
        "8, monitor:DP-3"
        "9, monitor:DP-3"
      ];
      general = {
        gaps_in = 6;
        gaps_out = 11;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
        allow_tearing = false;
        apply_sens_to_raw = 0;
      };
      decoration = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        rounding = 7;

        blur = {
          enabled = true;
          size = 3;
          passes = 3;
          ignore_opacity = false;
          new_optimizations = 1;
          xray = true;
          contrast = 0.7;
          brightness = 0.8;
        };

        drop_shadow = true;
        shadow_range = 20;
        shadow_render_power = 5;
        # col.shadow = "rgba(1a1a1aee)";
        "col.shadow" = "rgba(292c3cee)";
      };
      gestures = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        workspace_swipe = true;
        workspace_swipe_forever = true;
      };
    };
  };
}
