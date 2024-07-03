{pkgs, ...}: {
  yubikey-up = pkgs.writeShellApplication {
    name = "yubikey-up";
    runtimeInputs = builtins.attrValues {
      inherit
        (pkgs)
        gawk
        yubikey-manager
        ;
    };
    text = builtins.readFile ./yubikey-up.sh;
  };
  yubikey-down = pkgs.writeShellApplication {
    name = "yubikey-down";
    text = builtins.readFile ./yubikey-down.sh;
  };
}
