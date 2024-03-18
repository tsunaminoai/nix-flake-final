{
  home,
  pkgs,
  lib,
  config,
  ...
}: let
  common_excludes = [
    # nix
    "*/release"
    "*.qcow2"
    "*.vdi"
    "*.vmdk"
    "*.vhd"
    "*.vhdx"
    # caches
    ".cache"
    "*/cache2" # firefox
    "*/Cache"
    ".config/Slack/logs"
    ".config/Code/CachedData"
    ".container-diff"
    # node
    ".npm/_cacache"
    "*/node_modules"
    # python
    "*/_build"
    "*/.tox"
    "*/venv"
    "*/.venv"
    "*.pyc"
    "*.pyo"
    "*/__pycache__"
    # zig
    "*/zig-cache"
    "*/zig-out"
    # rust
    "*/target"
    # go
    "*/go/pkg"
    "*/go/bin"
    # C++
    "*/build"
    "*/build-clang"
    "*/build-gcc"
  ];
  cfg = config.services.borg-backup;
in {
  options.services.borg-backup = {
    enable = lib.mkEnableOption "borg-backup service";
    repo_id = lib.mkOption {
      type = lib.types.str;
      default = "home";
      example = "78538ed4";
      description = "The id of the repoistory in borgwarehouse";
    };
    root_directory = lib.mkOption {
      type = lib.types.str;
      default = "/";
      example = "/home";
      description = "The root directory to backup";
    };
  };

  config = lib.mkIf cfg.enable {
    services.borgmatic = {
      enable = true;
      frequency = "hourly";
    };
    programs.borgmatic = {
      enable = true;
      backups = {
        voile = {
          retention = {
            keepDaily = 7;
            keepWeekly = 4;
            keepMonthly = 6;
            keepYearly = 1;
          };
          location = {
            excludeHomeManagerSymlinks = true;
            sourceDirectories = [cfg.root_directory];

            repositories = [
              {
                path = "ssh://borgwarehouse@voile.armadillo-banfish.ts.net:22222/./${cfg.repo_id}";
                label = "BorgWarehouse";
              }
            ];
          };
        };
      };
    };
  };
}
