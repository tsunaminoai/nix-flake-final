{
  pkgs,
  lib,
  ...
}: let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in {
  services = lib.mkIf (!isDarwin) {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      enableExtraSocket = true;
      pinentryPackage = pkgs.pinentry-curses;
    };
  };
  programs.fish.interactiveShellInit = ''
    if test -f $HOME/.gnupg/gpg-agent.conf
      set -x GPG_TTY (tty)
      set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
      gpgconf --launch gpg-agent
    end
  '';
  programs.gpg = {
    enable = true;
  };
  home.file.".gnupg/gpg-agent.conf".text = ''
    # https://github.com/drduh/config/blob/master/gpg-agent.conf
    # https://www.gnupg.org/documentation/manuals/gnupg/Agent-Options.html
    #pinentry-program /usr/bin/pinentry-gnome3
    #pinentry-program /usr/bin/pinentry-tty
    #pinentry-program /usr/bin/pinentry-x11
    #pinentry-program /usr/local/bin/pinentry-curses
    #pinentry-program /usr/local/bin/pinentry-mac
    #pinentry-program /opt/homebrew/bin/pinentry-mac
    pinentry-program ${pkgs.pinentry-curses}/bin/pinentry-curses
    enable-ssh-support
    ttyname $GPG_TTY
    default-cache-ttl 60
    max-cache-ttl 120
  '';
}
