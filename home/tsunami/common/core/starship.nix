{
  lib,
  config,
  ...
}: let
  style = config.lib.stylix.colors;
in {
  # disable devbox prompt interaction
  home.sessionVariables = {
    DEVBOX_NO_PROMPT = "true";
  };
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableTransience = false;
    settings = {
      add_newline = false;

      format = lib.concatStrings [
        "[](color_blue)"
        "$username"
        "$os"
        "$hostname"
        "[ ](bg:color_cyan fg:color_blue)"
        "$directory"
        "[ ](bg:color_green fg:color_cyan)"
        "$git_branch"
        "$git_status"
        "[ ](bg:color_yellow fg:color_green)"
        "$direnv"
        "$c"
        "$elixir"
        "$elm"
        "$golang"
        "$gradle"
        "$haskell"
        "$java"
        "$julia"
        "$nodejs"
        "$nim"
        "$nix_shell"
        "$rust"
        "$scala"
        "$zig"
        "$docker_context"
        "[ ](fg:color_yellow)"
        "$line_break"
        "[](fg:color_purple)"
        "$time"
        "[](fg:color_purple)"
      ];

      palette = "stylix";
      palettes.stylix = {
        color_fg0 = "#" + style.base04;
        color_fg1 = "#" + style.base05;
        color_bg0 = "#" + style.base00;
        color_bg1 = "#" + style.base01;
        color_blue = "#" + style.base0D;
        color_cyan = "#" + style.base0C;
        color_green = "#" + style.base0B;
        color_orange = "#" + style.base09;
        color_purple = "#" + style.base0E;
        color_red = "#" + style.base08;
        color_yellow = "#" + style.base0A;
        color_brown = "#" + style.base0F;
      };

      username = {
        disabled = false;
        style_user = "fg:color_fg0 bg:color_blue";
        style_root = "fg:color_red bg:color_blue";
        format = "[$user]($style)";
        show_always = true;
      };

      hostname = {
        style = "fg:color_fg0 bg:color_blue";
        format = "[$hostname $ssh_symbol]($style)";
        ssh_only = false;
        ssh_symbol = "󰢩";
      };

      os = {
        disabled = false;
        style = "fg:color_fg0 bg:color_blue";
        format = "[ $symbol ]($style)";
        symbols = {
          Macos = "";
          Debian = "";
          Ubuntu = "";
          NixOS = "";
        };
      };
      direnv = {
        disabled = false;
        style = "bg:color_yellow fg:color_fg0";
        format = "[$symbol$loaded ]($style)";
        symbol = "";
        loaded_msg = "󰉋";
        # allowed_msg = "󰇵 ";
        # not_allowed_msg = " ";
        denied_msg = "";
        unloaded_msg = "";
      };

      directory = {
        style = "bg:color_cyan fg:color_fg0";
        format = "[$path ]($style)";
        fish_style_pwd_dir_length = 10;
        truncate_to_repo = true;
        truncation_symbol = "…/";
        truncation_length = 20;
        read_only = "";
        home_symbol = "~";
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
          "code" = " ";
        };
      };

      git_branch = {
        disabled = false;
        style = "bg:color_green fg:color_fg0";
        format = "[$symbol$branch ]($style)";
        symbol = "";
        truncation_length = 20;
      };

      git_status = {
        disabled = false;
        style = "bg:color_green fg:color_fg0";
        format = "[$conflicted$staged$modified$untracked$stashed$renamed$deleted ]($style)";
        ahead = "↑";
        behind = "↓";
        diverged = "↕";
        conflicted = "✖";
        staged = "✚";
        modified = "✱";
        untracked = "✭";
        stashed = "✭";
        renamed = "➜";
        deleted = "✖";
      };
      nix_shell = {
        disabled = false;
        style = "bg:color_yellow fg:color_fg0";
        format = "[$symbol $name ]($style)";
        symbol = "";
      };

      time = {
        disabled = false;
        style = "bg:color_purple fg:color_fg0";
        format = "[$time ]($style)";
        time_format = "%R"; # Hour:Minute Format
      };

      zig = {
        style = "bg:color_yellow fg:color_fg0";
        format = "[$symbol ($version) ]($style)";
        version_format = "v\${raw}";
        symbol = "󱐋";
      };
    };
  };
}
