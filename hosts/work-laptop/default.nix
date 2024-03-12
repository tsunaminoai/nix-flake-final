#############################################################
#
#  MacBook-Pro-0432
#  Macbook Pro 13" M1 (apple-silicon) Running nix-darwin
#
###############################################################
{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    #################### Required Configs ####################
    ../common/darwin
    ../common/security

    #################### Users to Create ####################
    ../common/users/bcraton
  ];

  networking = {
    hostName = "MacBook-Pro-0432";
  };
}
