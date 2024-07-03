{
  config,
  inputs,
  lib,
  pkgs,
  outputs,
  ...
}: let
  cfg = config.tsunaminoai.nix;

  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  darwinOptions = {
    services.nix-daemon.enable = true;
    nix = {
      package = pkgs.nix;
      nixPath = ["$HOME/.nix-defexpr/darwin"];
      gc = {
        automatic = true;
        interval = {
          Hour = 3;
          Minute = 15;
        };
      };
      linux-builder = {
        enable = true;
        ephemeral = false;
      };
      settings = {
        allowed-users = ["@admin"];
        cores = 4;
        sandbox = true;
        trusted-users = ["@admin"];
      };
    };
  };
  linuxOptions = {
    documentation.dev.enable = false;
  };
in {
  options.tsunaminoai.nix = with lib.types; {
    enable = lib.mkEnableOption "Enable nix configuration";
  };

  config = lib.mkMerge [
    {}
    lib.mkIf cfg.enable {
      # tools for working with nix
      environment.systemPackages = with pkgs; [
        deadnix # dead code detection
        alejandra # formats nix code
        statix # lints and suggests improvements to nix code
        nil # nix LSP
        nix-output-monitor # monitor nix builds
      ];

      # Set up nix packages configuration
      nixpkgs = {
        overlays = builtins.attrValues outputs.overlays;

        config = {
          allowUnfree = false;
          allowBroken = false;
          allowUnfreePredicate = pkg:
            builtins.elem (lib.getName pkg) [
              "nvidia-x11"
              "nvidia-settings"
              "vscode"
              "obsidian"`
            ];
        };
      };

      # faster rebuild times
      documentation = {
        enable = true;
        doc.enable = false;
        man.enable = true;
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
    }
    (lib.mkIf isDarwin darwinOptions)
  ];

}