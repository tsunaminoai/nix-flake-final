{lib, ...}: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableTransience = false;
    settings = {
      add_newline = false;

      format = lib.concatStrings [
        "[](fg:#115aa8)"
        "$username"
        "$os"
        "$hostname"
        "[](bg:#DA627D fg:#115aa8)"
        "$directory"
        "[](fg:#DA627D bg:#FCA17D)"
        "$git_branch"
        "$git_status"
        "[](fg:#FCA17D bg:#86BBD8)"
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
        "[](fg:#86BBD8 bg:#33658A)"
        "$time"
        "[](fg:#33658A)"
      ];

      username = {
        show_always = true;
        style_user = "bg:#115aa8";
        style_root = "bg:#115aa8";
        format = "[$user]($style)";
        disabled = false;
      };

      hostname = {
        style = "bg:#115aa8";
        ssh_only = false;
        ssh_symbol = "󰢩 ";
        format = "[$hostname$ssh_symbol ]($style)";
      };

      os = {
        style = "bg:#115aa8";
        disabled = false;
        format = "[$symbol]($style)";
        symbols = {
          Macos = "";
          Debian = "";
          Ubuntu = "";
          NixOS = "❄️";
        };
      };
      direnv = {
        symbol = "";
        style = "bg:#86BBD8 fg:#111111";
        format = "[$symbol$loaded ]($style)";
        disabled = false;
        loaded_msg = "󰉋 ";
        allowed_msg = "󰇵 ";
        # not_allowed_msg = " ";
        denied_msg = "  ";
        unloaded_msg = " ";
      };

      directory = {
        style = "bg:#DA627D";
        fish_style_pwd_dir_length = 10;
        truncate_to_repo = true;
        format = "[$path ]($style)";
        truncation_symbol = "…/";
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
        style = "bg:#FCA17D fg:#111111";
        format = "[$symbol$branch ]($style)";
        symbol = "";
        disabled = false;
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
        style = "bg:#FCA17D fg:#111111";
        disabled = false;
      };
      nix_shell = {
        symbol = "❄️";
        style = "bg:#86BBD8 fg:#111111";
        format = "[$symbol($name) ]($style)";
        disabled = false;
      };

      time = {
        disabled = false;
        time_format = "%R"; # Hour:Minute Format
        style = "bg:#33658A";
        format = "[$time ]($style)";
      };

      zig = {
        symbol = "⚡️ ";
        style = "bg:#86BBD8 fg:#111111";
        version_format = "v\${raw}";
        format = "[$symbol($version) ]($style)";
      };
    };
  };
}
