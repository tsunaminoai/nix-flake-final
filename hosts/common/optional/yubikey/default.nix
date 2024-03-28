# Modeled on https://github.com/Mic92/dotfiles for now
{
  pkgs,
  lib,
  ...
}: let
  scripts = import ./scripts {inherit pkgs;};
in {
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
}
