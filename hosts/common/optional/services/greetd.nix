#
# greeter -> tuigreet https://github.com/apognu/tuigreet?tab=readme-ov-file
# display manager -> greetd https://man.sr.ht/~kennylevinsen/greetd/
#
{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.autoLogin;
in {
  # Declare custom options for conditionally enabling auto login
  options.autoLogin = {
    enable = lib.mkEnableOption "Enable automatic login";

    username = lib.mkOption {
      type = lib.types.str;
      default = "guest";
      description = "User to automatically login";
    };
  };

  config = {
    #    environment.systemPackages = with pkgs; [ greetd.tuigreet ];
    services.greetd = {
      enable = true;

      restart = true;
      settings = {
        default_session = {
          default_session.command = ''
            ${pkgs.greetd.tuigreet}/bin/tuigreet \
              --time \
              --asterisks \
              --user-menu \
              --cmd sway
          '';
        };

        initial_session = lib.mkIf cfg.enable {
          command = "${pkgs.sway}/bin/sway";
          user = "${cfg.username}";
        };
      };
    };
  };
}
