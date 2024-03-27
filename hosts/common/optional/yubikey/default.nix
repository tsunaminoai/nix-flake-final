# Modeled on https://github.com/Mic92/dotfiles for now
{
  pkgs,
  lib,
  ...
}: let
  isLinux = pkgs.stdenv.hostPlatform.isLinux;

  scripts = {
    yubikey-up = pkgs.writeShellApplication {
      name = "yubikey-up";
      runtimeInputs = builtins.attrValues {
        inherit
          (pkgs)
          gawk
          yubikey-manager
          ;
      };
      text = builtins.readFile ./scripts/yubikey-up.sh;
    };
    yubikey-down = pkgs.writeShellApplication {
      name = "yubikey-down";
      text = builtins.readFile ./scripts/yubikey-down.sh;
    };
  };
  linux-services = import ./linux-services.nix {inherit pkgs lib scripts;};
in {
  imports = [
    (lib.mkIf isLinux linux-services)
  ];
  environment.systemPackages = with pkgs; [
    gnupg
    # yubikey-personalization
    # Yubico's official tools
    #    yubikey-manager
    #    yubikey-manager-qt
    #    yubikey-personalization
    #    yubikey-personalization-gui
    #    yubico-piv-tool
    #    yubioath-flutter # yubioath-desktop on older nixpkg channels
    pam_u2f # for yubikey with sudo

    scripts.yubikey-up
    scripts.yubikey-down
    yubikey-manager # For ykman
  ];
  # system = lib.mkIf isLinux linux-services;
  # security = lib.mkIf isLinux linux-services.security;
}
