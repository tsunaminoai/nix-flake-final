{
  pkgs,
  lib,
  ...
}: {
  programs.tmux = {
    enable = true;
    shortcut = "a";
    keyMode = "emacs";
    baseIndex = 1;
    clock24 = true;
    newSession = true;
    secureSocket = false;
    mouse = true;
    prefix = "C-a";
    # terminal = "xterm-256color";
    terminal = "tmux-256color";
    escapeTime = 50;
    historyLimit = 30000;
    extraConfig = ''
      set -ga terminal-overrides ",xterm-256color:RGB"
    '';
    sensibleOnTop = true;
    plugins = with pkgs.tmuxPlugins; [
      #      cpu
      #      yank
      #      {
      #        plugin = weather;
      #        extraConfig = ''
      #          set-option -g @tmux-weather-location "klaf"
      #          set-option -g @tmux-weather-units "u"
      #          set-option -g @tmux-weather-format "%c+%t+%w"
      #          set-option -g status-left "#{weather}"
      #        '';
      #      }
      #      {
      #        plugin = better-mouse-mode;
      #        extraConfig = ''
      #          set -g @scroll-without-changing-pane "on"
      #          set -g @scroll-speed-num-lines-per-scroll "1"
      #        '';
      #      }
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour 'macchiato'
          set -g @catppuccin_date_time "%a %b-%d %H:%M"
        '';
      }
    ];
  };
}
