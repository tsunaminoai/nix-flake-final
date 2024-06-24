#############################################################
#
#  Media Macmini
#  MacMini (Macmini5,1)
#
###############################################################
{lib , ...}: {
  imports = [
    #################### Required Configs ####################
    ../common/darwin
    ../common/security

    #################### Users to Create ####################
    ../common/users/tsunami-darwin
  ];
  homebrew = lib.mkDefault {
    enable = false;
  };
  networking = {
    hostName = "bedford-media-macmini";
  };
}
