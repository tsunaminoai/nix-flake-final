{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ../gtk.nix
  ];

  home.sessionVariables.WLR_RENDERER = lib.mkForce "gles2";
  programs.swaylock = {
    enable = true;
    settings = {
      screenshots = true;
      clock = true;
      color = "808080";
      font-size = 24;
      indicator-idle-visible = false;
      indicator-radius = 100;
      indicator-thickness = 7;
      effect-blur = "7x5";
      effect-vignette = "0.5:0.5";
      ring-color = "bb00cc";
      key-hl-color = "880033";
      line-color = "00000000"; #RGBA
      inside-color = "00000088"; #RGBA
      show-failed-attempts = true;
      separator-color = "00000000"; #RGBA
      grace = 2;
      fade-in = 0.2;
    };
    package = pkgs.swaylock-effects; # the effects currently dont work
  };
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 60 * 5; # 5 minutes
        command = "${pkgs.swaylock-effects}/bin/swaylock -fF";
      }
      {
        timeout = 60 * 60 * 6; # 6 hours
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
  };

  home.packages = with pkgs; [
    swayidle
    wl-clipboard
    mako
    wofi
    waybar
  ];

  wayland.windowManager.sway = {
    extraOptions = ["--unsupported-gpu"];
    enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = "alacritty";
      menu = "wofi --show run";
      bars = [
        {
          fonts = {
            names = ["DejaVu Sans Mono" "Terminus"];
            style = "Semi-Condensed";
            size = 16.0;
          };
          command = "waybar";
          position = "top";
        }
      ];

      fonts = {
        names = ["DejaVu Sans Mono" "Terminus"];
        style = "Semi-Condensed";
        size = 16.0;
      };
      floating = {
        titlebar = true;
        criteria = [{class = "Pavucontrol";}];
        border = 2;
      };

      startup = [
        {command = "exec sleep 5; systemctl --user start kanshi.service";}
        # Launch Firefox on start
        # {command = "firefox";}
      ];

      keybindings = let
        modifier = config.wayland.windowManager.sway.config.modifier;
      in
        lib.mkOptionDefault {
          "${modifier}+Shift+q" = "kill";
          "${modifier}+h" = "split h";
          "${modifier}+v" = "split v";
          "${modifier}+f" = "fullscreen toggle";
          "${modifier}+space" = "focus mode_toggle";
          "${modifier}+l" = "exec swaylock";
          "${modifier}+Shift+space" = "floating toggle";
        };
    };
    systemd.xdgAutostart = true;
  };

  home.file.".config/i3/config.reference".text = ''

    # TODO: Convert the remaining i3 config to sway config

    # Define names for default workspaces for which we configure key bindings later on.
    # We use variables to avoid repeating the names in multiple places.
    set $ws1 "1: General"
    set $ws2 "2: Work"
    set $ws3 "3:  Code"
    set $ws4 "4"
    set $ws5 "5"
    set $ws6 "6"
    set $ws7 "7"
    set $ws8 "8"
    set $ws9 "9"
    set $ws10 "10"

    # switch to workspace
    bindsym $mod+1 workspace number $ws1
    bindsym $mod+2 workspace number $ws2
    bindsym $mod+3 workspace number $ws3
    bindsym $mod+4 workspace number $ws4
    bindsym $mod+5 workspace number $ws5
    bindsym $mod+6 workspace number $ws6
    bindsym $mod+7 workspace number $ws7
    bindsym $mod+8 workspace number $ws8
    bindsym $mod+9 workspace number $ws9
    bindsym $mod+0 workspace number $ws10

    # move focused container to workspace
    bindsym $mod+Shift+1 move container to workspace number $ws1
    bindsym $mod+Shift+2 move container to workspace number $ws2
    bindsym $mod+Shift+3 move container to workspace number $ws3
    bindsym $mod+Shift+4 move container to workspace number $ws4
    bindsym $mod+Shift+5 move container to workspace number $ws5
    bindsym $mod+Shift+6 move container to workspace number $ws6
    bindsym $mod+Shift+7 move container to workspace number $ws7
    bindsym $mod+Shift+8 move container to workspace number $ws8
    bindsym $mod+Shift+9 move container to workspace number $ws9
    bindsym $mod+Shift+0 move container to workspace number $ws10

    # reload the configuration file
    bindsym $mod+Shift+c reload
    # restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
    bindsym $mod+Shift+r restart
    # exit i3 (logs you out of your X session)
    bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'"

    # resize window (you can also use the mouse for that)
    mode "resize" {
            # These bindings trigger as soon as you enter the resize mode

            # Pressing left will shrink the window’s width.
            # Pressing right will grow the window’s width.
            # Pressing up will shrink the window’s height.
            # Pressing down will grow the window’s height.
            bindsym j resize shrink width 10 px or 10 ppt
            bindsym k resize grow height 10 px or 10 ppt
            bindsym l resize shrink height 10 px or 10 ppt
            bindsym semicolon resize grow width 10 px or 10 ppt

            # same bindings, but for the arrow keys
            bindsym Left resize shrink width 10 px or 10 ppt
            bindsym Down resize grow height 10 px or 10 ppt
            bindsym Up resize shrink height 10 px or 10 ppt
            bindsym Right resize grow width 10 px or 10 ppt

            # back to normal: Enter or Escape or $mod+r
            bindsym Return mode "default"
            bindsym Escape mode "default"
            bindsym $mod+r mode "default"
    }

    bindsym $mod+r mode "resize"

    # Start i3bar to display a workspace bar (plus the system information i3status
    # finds out, if available)
    bar {
    	output		DP-2
      status_command 	i3status
    	position	top
    	mode		dock
    	workspace_buttons	yes
    	tray_output	none

    	font pango:DejaVu Sans Mono, Icons 8

    	colors {
    		background	#000000
    		statusline	#ffffff

    		focused_workspace	#ffffff #285577
    		active_workspace	#ffffff	#333333
    		inactive_workspace	#888888	#222222
    		urgent_workspace		#ffffff	#900000
    	}
    }
    bar {
    	output		DP-4
      status_command 	i3status
    	position	top
    	mode		dock
    	workspace_buttons	yes
    	tray_output	primary
      tray_padding 2
      separator_symbol "󰇙"

    	font pango:DejaVu Sans Mono, Icons 8

    	colors {
    		background	#000000
    		statusline	#ffffff

    		focused_workspace	#ffffff #285577
    		active_workspace	#ffffff	#333333
    		inactive_workspace	#888888	#222222
    		urgent_workspace		#ffffff	#900000
    	}
    }


    # # Shortcut for Lockscreen
    # bindsym $mod+l exec ~/.config/scripts/lock

    # Hide borders
    hide_edge_borders smart

    # Gaps
    gaps inner 10
    gaps outer 10
    smart_gaps on
  '';
}
