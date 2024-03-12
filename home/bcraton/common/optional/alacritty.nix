{
  home,
  pkgs,
  ...
}: {
  programs.alacritty = {
    enable = true;
    settings = {
      live_config_reload = true; # no point when using nix
      shell = "fish";
      window = {
        dimensions = {
          columns = 80;
          lines = 24;
        };
        padding = {
          x = 5;
          y = 5;
        };
        dynamic_padding = true;
        decorations = "Full";
        opacity = 0.9;
        blur = true;
        startup_mode = "Windowed";
        dynamic_title = true;
        decorations_theme_variant = "Dark";
      };
      scrolling = {
        history = 10000;
        multiplier = 3;
      };
      font = {
        normal = {
          family = "JetBrainsMono";
          style = "Regular";
        };
        size = 11;
        builtin_box_drawing = true;
        glyph_offset = {
          x = 3;
          y = 0;
        };
      };
      colors = {
      };

      bell = {
        animation = "EaseOutQuart";
        duration = 200;
      };

      selection = {
        save_to_clipboard = true;
      };

      cursor = {
        style = {
          shape = "Beam";
          blinking = "On";
        };
        blink_timeout = 5;
        unfocused_hollow = false;
        thickness = 0.2;
      };

      mouse = {
        hide_when_typing = true;
        bindings = [
          {
            mouse = "Right";
            action = "Paste";
          }
        ];
      };

      hints.enabled = [
        {
          command =
            if pkgs.stdenv.isDarwin
            then "open"
            else "xdg-open";
          hyperlinks = true;
          post_processing = true;
          persist = false;
          mouse.enabled = true;
          binding = {
            key = "U";
            mods = "Control|Shift";
          };
          regex = ''
            (ipfs:|ipns:|magnet:|mailto:|gemini://|gopher://|https://|http://|news:|file:|git://|ssh:|ftp://)[^\u0000-\u001F\u007F-\u009F<>"\\s{-}\\^⟨⟩`]+
          '';
        }
      ];

      keyboard = {
        bindings = [
          {
            key = "v";
            mods = "Control";
            action = "Paste";
          }
          {
            key = "N";
            mods = "Control|Shift";
            action = "CreateNewWindow";
          }
        ];
      };
    };
  };
}
