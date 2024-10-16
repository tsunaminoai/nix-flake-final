{
  config,
  lib,
  pkgs,
  outputs,
  ...
}: let
  homeRoot =
    if pkgs.stdenv.hostPlatform.isDarwin
    then "/Users"
    else "/home";
in {
  # import the theme
  _module.args.theme = import ./theme;

  # stylix = {
  #   image = pkgs.fetchurl {
  #     url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
  #     sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
  #   };

  #   base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
  #   polarity = "dark";
  # };
  imports = [
    # Packages with custom configs go here
    ./alacritty.nix # terminal
    ./bash.nix # backup shell
    ./bat.nix # cat with better syntax highlighting and extras like batgrep.
    ./direnv.nix # shell environment manager. Hooks inot shell direnv to look for .envrc before prompts
    ./fish.nix # fish shell
    ./fonts.nix # core fonts
    ./gh.nix # github cli
    ./gnupg.nix # gpg and agent
    ./git.nix # personal git config
    ./kitty.nix # terminal
    ./nano.nix # nano editor
    ./screen.nix # hopefully rarely needed but good to have if so
    ./ssh.nix # personal ssh configs
    ./starship.nix # prompt
    ./taskwarrior.nix # task manager
    ./tmux.nix # terminal multiplexer
    ./zoxide.nix # cd replacement
    ./stylix.nix # theme
  ];
  # ++ (builtins.attrValues outputs.homeManagerModules);

  home = {
    username = lib.mkDefault "tsunami";
    homeDirectory = lib.mkDefault "/${homeRoot}/${config.home.username}";
    stateVersion = lib.mkDefault "23.05";
    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/scripts/talon_scripts"
    ];
    sessionVariables = {
      FLAKE = "$HOME/code/nix/nix-flake-final";
      SHELL = "fish";
      #      TERM = "kitty";
      #      TERMINAL = "kitty";
      EDITOR = "nano";
      # TODO: investigate if this is needed
      # MANPAGER = "batman"; # see ./cli/bat.nix
    };
  };

  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      # Packages that don't have custom configs go here
      
      alejandra # formatter
      # TODO: fix borg backups on x86_64-darwin and find a holistic way to do backups automatically
      
      # borgbackup # backups
      
      btop # resource monitor
      coreutils # basic gnu utils
      #curl
      
      eza # ls replacement
      dust # better du
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
      zip # zip compression
      zoxide # cd replacement
      ;
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
      experimental-features = ["nix-command" "flakes"];
      warn-dirty = false;
    };
  };

  programs = {
    home-manager.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = lib.mkIf (pkgs.stdenv.hostPlatform.isLinux) "sd-switch";
}
