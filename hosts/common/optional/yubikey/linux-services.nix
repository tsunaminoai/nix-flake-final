# TODO: This needs to be a module that can be included in the main config
{
  pkgs,
  scripts,
  lib,
  ...
  
}: {
  services = {
    # FIXME: Put this behind an option for yubikey ssh
    # Create ssh files

    # FIXME: Not sure if we need the wheel one. Also my idProduct gruop is 0407
    # Yubikey 4/5 U2F+CCID
    # SUBSYSTEM == "usb", ATTR{idVendor}=="1050", ENV{ID_SECURITY_TOKEN}="1", GROUP="wheel"
    # We already have a yubikey rule that sets the ENV variable

    udev.extraRules = ''
      # Link/unlink ssh key on yubikey add/remove
      SUBSYSTEM=="usb", ACTION=="add", ATTR{idVendor}=="1050", RUN+="${lib.getBin scripts.yubikey-up}/bin/yubikey-up"
      SUBSYSTEM=="input", ACTION=="remove", ENV{ID_VENDOR_ID}=="1050", RUN+="${lib.getBin scripts.yubikey-down}/bin/yubikey-down"
    '';
    # Yubikey required services and config. See Dr. Duh NixOS config for
    # reference
    pcscd.enable = true; # smartcard service

    udev.packages = with pkgs; [
      yubikey-personalization
    ];
  };

  security = {
    # FIXME: Need to create symlinks to the sops-decrypted keys
    #
    polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
            if (action.id == "org.debian.pcsc-lite.access_card" &&
                      subject.isInGroup("wheel")) {
                      return polkit.Result.YES;
              }
      });
      polkit.addRule(function(action, subject) {
              if (action.id == "org.debian.pcsc-lite.access_pcsc" &&
                      subject.isInGroup("wheel")) {
                      return polkit.Result.YES;
              }
      });
    '';
    # enable pam services to allow u2f auth for login and sudo
    pam.services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };

    # enable pam.u2f
    # u2f_keys are extracted from secrets.yaml to default `~/.config/Yubico/u2f_keys` location via ../../core/sops.nix

    #FIXME /etc/pam.d/sudo is being written but there is other stuff in there with higher order that may be interfering. Also doesn't seem that this will work over ssh either so may have to wait.
    pam.u2f = {
      enable = true;
      control = "sufficient";
      cue = true; # A reminder message will be displayed prompting user to use u2f device

      # override defaults `pam://$HOSTNAME` so that they match the keys and work across hosts
      origin = "pam://hostname";
      appId = "pam://hostname";
    };
  };
}
