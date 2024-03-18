{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.testconfig;
in {
  options.testconfig = {
    enable = mkEnableOption "Enable testconfig";
    text = mkOption {
      type = types.str;
      default = "hello";
      description = "Test config";
    };
  };

  config = mkIf cfg.enable {
    testconfig.text = cfg.text;
  };
}
