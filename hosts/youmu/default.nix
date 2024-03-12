#############################################################
#
#  Youmu
#  Macbook Pro 15" x86_64 (2017)
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
    ../common/users/tsunami
  ];

  networking = {
    hostName = "youmu";
  };
}
