{
  config,
  lib,
  pkgs,
  outputs,
  ...
}: {
  imports =
    [
      # Packages with custom configs go here

      ./bash.nix # backup shell
      ./bat.nix # cat with better syntax highlighting and extras like batgrep.
      ./direnv.nix # shell environment manager. Hooks inot shell direnv to look for .envrc before prompts
      ./fonts.nix # core fonts
      ./fish.nix # fish shell
      ./git.nix # personal git config
      ./kitty.nix # terminal
      # ./nixvim # vim goodness
      ./nano.nix # nano editor
      ./screen.nix # hopefully rarely needed but good to have if so
      ./ssh.nix # personal ssh configs
      ./starship.nix # prompt
      ./taskwarrior.nix # task manager
      ./tmux.nix # terminal multiplexer
      ./zoxide.nix # cd replacement
      # ./zsh # primarly shell: includes zsh, oh-my-zsh, and p10k theme

      # TODO Not set, need to investigate but will need custom config if used:
      #./shellcolor.nix
    ]
    ++ (builtins.attrValues outputs.homeManagerModules);

  home = {
    username = lib.mkDefault "tsunami";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "23.05";
    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/scripts/talon_scripts"
    ];
    sessionVariables = {
      FLAKE = "$HOME/code/nix/nix-flake-final";
      SHELL = "fish";
      TERM = "kitty";
      TERMINAL = "kitty";
      EDITOR = "nano";
      MANPAGER = "batman"; # see ./cli/bat.nix
    };
  };

  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      # Packages that don't have custom configs go here
      
      alejandra # formatter
      # borgbackup # backups
      
      btop # resource monitor
      coreutils # basic gnu utils
      #curl
      
      eza # ls replacement
      fd # tree style ls
      findutils # find
      fzf # fuzzy search
      jq # JSON pretty printer and manipulator
      nix-tree # nix package tree viewer
      pfetch # system info
      pre-commit # git hooks
      p7zip # compresion & encryption
      ripgrep # better grep
      tree # cli dir tree viewer
      unzip # zip extraction
      unrar # rar extraction
      wget # downloader
      zip
      ; # zip compression
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = ["nix-command" "flakes" "repl-flake"];
      warn-dirty = false;
    };
  };

  programs = {
    home-manager.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
