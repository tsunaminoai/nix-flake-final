{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  lib,
  # An instance of `pkgs` with your overlays and packages applied is also available.
  pkgs,
  # You also have access to your flake's inputs.
  inputs,
  # Additional metadata is provided by Snowfall Lib.
  namespace, # The namespace used for your flake, defaulting to "internal" if not set.
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.
  # All other arguments come from the module system.
  config,
  ...
}: let
  cfg = config.${namespace}.nix;
in {
  options.tsunaminoai = with lib.types; {
    nix = {
      enable = lib.mkEnableOption "Enable nix configuration";
      dev = lib.mkEnableOption "Enable nix development tools";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.dev {
      # tools for working with nix
      environment.systemPackages = with pkgs; [
        deadnix # dead code detection
        alejandra # formats nix code
        statix # lints and suggests improvements to nix code
        nil # nix LSP
        nix-output-monitor # monitor nix builds
      ];
    })
    (lib.mkIf cfg.enable {
      # Set up nix packages configuration
      nixpkgs = {
        config = {
          allowUnfree = false;
          allowBroken = false;
          allowUnfreePredicate = pkg:
            builtins.elem (lib.getName pkg) [
              "nvidia-x11"
              "nvidia-settings"
              "vscode"
              "obsidian"
            ];
        };
      };

      # faster rebuild times
      documentation = {
        enable = true;
        doc.enable = false;
        man.enable = true;
        documentation.dev.enable = false;
      };

      programs.nh = {
        enable = true;
        clean.enable = false;
        clean.extraArgs = "--keep-since 4d --keep 3";
      };

      # nix package manager configuration
      nix = {
        settings = {
          auto-optimise-store = true;
          builders-use-substitutes = true;

          experimental-features = ["nix-command" "flakes" "repl-flake"];
          warn-dirty = false;
          allowed-users = ["@wheel"];
          trusted-users = ["@wheel"];
          max-jobs = "auto";

          # continue building derivations if one fails
          keep-going = true;

          log-lines = 20;
          sandbox = true;
          system-features = ["kvm" "big-parallel" "nixos-test"];
          flake-registry = ""; # Disable global flake registry   This is a hold-over setting from Misterio77. Not sure significance but likely to do with nix.registry entry below.

          # use binary cache, its not gentoo
          substituters = [
            "https://cache.nixos.org"
            "https://nix-community.cachix.org"
            "https://nixpkgs-unfree.cachix.org"
          ];

          trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
          ];
        };

        # Make builds run with low priority so the system stays responsive
        daemonCPUSchedPolicy = "idle";
        daemonIOSchedClass = "idle";

        # pin the registry to avoid downloading and evaling a new nixpkgs version every time
        # registry = lib.mapAttrs (_: v: {flake = v;}) inputs;

        # This will additionally add your inputs to the system's legacy channels
        # Making legacy nix commands consistent as well, awesome!
        # nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

        # Garbage Collection
        gc = {
          automatic = true;
          dates = "daily";
          randomizedDelaySec = "14m";
          options = "--delete-older-than 3d";
        };

        # Free up to 1GiB whenever there is less than 100MiB left.
        extraOptions = ''
          experimental-features = nix-command flakes recursive-nix
          keep-outputs = true
          warn-dirty = false
          keep-derivations = true
          min-free = ${builtins.toString (100 * 1024 * 1024)}
          max-free = ${builtins.toString (1024 * 1024 * 1024)}
        '';
      };
    })
  ];
}