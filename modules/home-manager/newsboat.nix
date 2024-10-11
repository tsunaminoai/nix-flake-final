{
  lib,
  config,
  ...
}: let
  cfg = config.tsunaminoai.news;
in {
  options.tsunaminoai.news = {
    enable = lib.mkEnableOption "Enable newsboat";
    autoReload = lib.mkEnableOption "Enable auto reload";
    reloadTime = lib.mkOption {
      type = lib.types.int;
      default = 15;
      description = "Time in minutes to reload feeds";
    };
    urls = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          url = lib.mkOption {
            type = lib.types.str;
            description = "URL of the feed";
          };
          tags = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
            description = "Tags to add to the feed";
          };
          title = lib.mkOption {
            type = lib.types.str;
            description = "Title of the feed";
          };
        };
      });
      default = [];
      description = "List of feeds to follow";
    };
  };
  config = {
    programs.newsboat = {
      enable = cfg.enable;
      autoReload = cfg.autoReload;
      reloadTime = cfg.reloadTime;
      urls = cfg.urls;
    };
  };
}
