{lib, ...}: {
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
        "[](bg:color_green fg:color_blue)"
        "$directory"
        "[](bg:color_aqua fg:color_green)"
        "$git_branch"
        "$git_status"
        "[](bg:color_yellow fg:color_aqua)"
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

      palette = "gruvbox_dark";
      palettes.gruvbox_dark = {
        color_fg0 = "#fbf1c7";
        color_bg1 = "#3c3836";
        color_bg3 = "#665c54";
        color_blue = "#458588";
        color_aqua = "#689d6a";
        color_green = "#98971a";
        color_orange = "#d65d0e";
        color_purple = "#b16286";
        color_red = "#cc241d";
        color_yellow = "#d79921";
      };

      username = {
        show_always = true;
        style_user = "fg:color_fg0 bg:color_blue";
        style_root = "fg:color_red bg:color_blue";
        format = "[$user]($style)";
        disabled = false;
      };

      hostname = {
        style = "fg:color_fg0 bg:color_blue";
       ssh_only = false;
        ssh_symbol = "󰢩";
        format = "[$hostname $ssh_symbol]($style)";
      };

      os = {
        style = "fg:color_fg0 bg:color_blue";
        disabled = false;
        format = "[$symbol]($style)";
        symbols = {
          Macos = "";
          Debian = "";
          Ubuntu = "";
          NixOS = "";
        };
      };
      direnv = {
        symbol = "";
        style = "bg:color_yellow fg:color_fg0";
        format = "[$symbol$loaded ]($style)";
        disabled = false;
        loaded_msg = "󰉋";
        # allowed_msg = "󰇵 ";
        # not_allowed_msg = " ";
        denied_msg = "";
        unloaded_msg = "";
      };

      directory = {
        style = "bg:color_green fg:color_fg0";
        fish_style_pwd_dir_length = 10;
        truncate_to_repo = true;
        format = "[$path ]($style)";
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
        style = "bg:color_aqua fg:color_fg0";
        format = "[$symbol$branch ]($style)";
        symbol = "";
        disabled = false;
        truncation_length = 20;
      };

      git_status = {
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
        format = "[$conflicted$staged$modified$untracked$stashed$renamed$deleted ]($style)";
        style = "bg:color_aqua fg:color_fg0";
        disabled = false;
      };
      nix_shell = {
        symbol = "";
        style = "bg:color_yellow fg:color_fg0";
        format = "[$symbol$name ]($style)";
        disabled = false;
      };

      time = {
        disabled = false;
        time_format = "%R"; # Hour:Minute Format
        style = "bg:color_purple fg:color_fg0";
        format = "[$time ]($style)";
      };

      zig = {
        symbol = "⚡️ ";
        style = "bg:color_yellow fg:color_fg0";
        version_format = "v\${raw}";
        format = "[$symbol($version) ]($style)";
      };
    };
  };
}
