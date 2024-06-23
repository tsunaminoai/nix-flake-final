#############################################################
#
#  Media Macmini
#  MacMini (Macmini5,1)
#
###############################################################
{...}: {
  imports = [
    #################### Required Configs ####################
    ../common/darwin
    ../common/security

    #################### Users to Create ####################
    ../common/users/tsunami-darwin
  ];

  networking = {
    hostName = "bedford-media-macmini";
  };
}
