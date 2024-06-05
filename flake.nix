{
  description = "TsunamiNoAi's Nix-Config";

  inputs = {
    #################### Official NixOS Package Sources ####################

    nixpkgs.url = "github:NixOS/nixpkgs/release-24.05"; 
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable"; # also see 'unstable-packages' overlay at 'overlays/default.nix"

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    #################### Utilities ####################

    # Declarative partitioning and formatting
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Official NixOS hardware packages
    hardware = {
      url = "github:nixos/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Secrets management. See ./docs/secretsmgmt.md
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home-manager for declaring user/home configurations
    home-manager = {
      url = "github:nix-community/home-manager"; #/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Weekly updated nix-index database [maintainer=@Mic92]
    nix-index-db = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Simplify Nix Flakes with the module system
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # Numtide's utilities

    # Devshell for declarative shell environments
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Flake utilities
    # flake-utils = {
    #   url = "github:numtide/flake-utils";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # Windows management

    hyprland = {
      url = "github:hyprwm/Hyprland/";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprcontrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Status bar
    barbie = {
      url = "github:sioodmy/barbie";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        flake-parts.follows = "flake-parts";
      };
    };

    # a tree-wide formatter
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # pre-commit hooks
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nice looking terminal
    catppuccinifier = {
      url = "github:lighttigerXIV/catppuccinifier";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # tui editor
    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # VSCode Server
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #################### Personal Repositories ####################

    # Private secrets repo.  See ./docs/secretsmgmt.md
    # Authenticate via ssh and use shallow clone
    mysecrets = {
      url = "git+ssh://git@github.com/tsunaminoai/nix-secrets.git?ref=master&shallow=1";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    devshell,
    home-manager,
    stylix,
    hardware,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
    systems = [
      "x86_64-linux"
      #"AArch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
      #"i686-linux"
    ];
    forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs systems (system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [devshell.overlays.default];
      });
  in {
    inherit lib; # Expose lib for use in custom modules

    # Custom modules to enable special functionality for nixos or home-manager oriented configs.
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    # Custom modifications/overrides to upstream packages.
    overlays = import ./overlays {inherit inputs outputs;};

    # Your custom packages meant to be shared or upstreamed.
    # Accessible through 'nix build', 'nix shell', etc
    packages = forEachSystem (pkgs: import ./pkgs {inherit pkgs;});

    # Nix formatter available through 'nix fmt' https://nix-community.github.io/nixpkgs-fmt
    formatter = forEachSystem (pkgs: pkgs.nixpkgs-fmt);

    # Shell configured with packages that are typically only needed when working on or with nix-config.
    devShells = forEachSystem (pkgs: {
      default = pkgs.devshell.mkShell {
        imports = [(pkgs.devshell.importTOML ./devshell.toml)];
      };
    });

    #################### NixOS Configurations ####################
    #
    # Available through 'nixos-rebuild --flake .#hostname'
    # Typically adopted using 'sudo nixos-rebuild switch --flake .#hostname'

    nixosConfigurations = {
      # Ishtar VM on Ereshkigal (Proxmox)
      ishtar = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [./hosts/ishtar];
        specialArgs = {inherit inputs outputs;};
      };
      # Mokou Desktop
      mokou = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [./hosts/mokou];
        specialArgs = {inherit inputs outputs;};
      };

      installerIso = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/common/optional/installeriso.nix
        ];
      };

<<<<<<< HEAD
      test-vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/test-vm
        ];
      };
      # # theatre
      # gusto = lib.nixosSystem {
      #   modules = [./hosts/gusto];
      #   specialArgs = {inherit inputs outputs;};
      # };
=======
>>>>>>> d34b018 (Clean up unused inputs. Fix issue with darwin store caching)
    };

    darwinConfigurations = {
      # Work Laptop
      "MacBook-Pro-0432" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [./hosts/work-laptop];
        specialArgs = {inherit inputs outputs;};
      };
      "youmu" = nix-darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = [./hosts/youmu];
        specialArgs = {inherit inputs outputs;};
      };
    };

    #################### User-level Home-Manager Configurations ####################
    #
    # Available through 'home-manager --flake .#primary-username@hostname'
    # Typically adopted using 'home-manager switch --flake .#primary-username@hostname'

    homeConfigurations = {
      "bcraton@MacBook-Pro-0432" = lib.homeManagerConfiguration {
        modules = [
          stylix.homeManagerModules.stylix
          ./home/tsunami/work-laptop.nix
        ];
        pkgs = pkgsFor.aarch64-darwin;
        extraSpecialArgs = {inherit inputs outputs;};
      };
      "tsunami@youmu" = lib.homeManagerConfiguration {
        modules = [
          stylix.homeManagerModules.stylix
          ./home/tsunami/youmu.nix
        ];
        pkgs = pkgsFor.x86_64-darwin;
        extraSpecialArgs = {inherit inputs outputs;};
      };
      "tsunami@ishtar" = lib.homeManagerConfiguration {
        modules = [
          stylix.homeManagerModules.stylix
          ./home/tsunami/ishtar.nix
        ];
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
      };
      "tsunami@mokou" = lib.homeManagerConfiguration {
        modules = [
          stylix.homeManagerModules.stylix
          ./home/tsunami/mokou.nix
        ];
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
      };
      # "ta@grief" = lib.homeManagerConfiguration {
      #   modules = [./home/ta/grief.nix];
      #   pkgs = pkgsFor.x86_64-linux;
      #   extraSpecialArgs = {inherit inputs outputs;};
      # };
      # "ta@guppy" = lib.homeManagerConfiguration {
      #   modules = [./home/ta/guppy.nix];
      #   pkgs = pkgsFor.x86_64-linux;
      #   extraSpecialArgs = {inherit inputs outputs;};
      # };
      # "media@gusto" = lib.homeManagerConfiguration {
      #   modules = [./home/media/gusto.nix];
      #   pkgs = pkgsFor.x86_64-linux;
      #   extraSpecialArgs = {inherit inputs outputs;};
      # };
      # "ta@gusto" = lib.homeManagerConfiguration {
      #   modules = [./home/ta/gusto.nix];
      #   pkgs = pkgsFor.x86_64-linux;
      #   extraSpecialArgs = {inherit inputs outputs;};
      # };
    };

    #################### DevShell Configurations ####################
  };
}
