#############################################################
#
#  MacBook-Pro-0432
#  Macbook Pro 13" M1 (apple-silicon) Running nix-darwin
#
###############################################################
{
  inputs,
  outputs,
  ...
}: {
  imports = [
    #################### Required Configs ####################
    ../common/core
    ../common/security
    ../common/optional/yubikey

    #################### Users to Create ####################
    ../common/users/bcraton
  ];

  # # This is because texlive uses way more symlinks than 65535
  # nix.settings.sandbox = lib.mkForce "relaxed";
  # system.systemBuilderArgs = {
  #   sandboxProfile = ''
  #     (allow file-read* file-write* process-exec mach-lookup (subpath "${builtins.storeDir}"))
  #   '';
  # };

  config = {
    tsunaminoai.nix.enable = true;

    networking = {
      hostName = "MacBook-Pro-0432";
    };
  };
}
