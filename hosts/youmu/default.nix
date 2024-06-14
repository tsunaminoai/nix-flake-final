#############################################################
#
#  Youmu
#  Macbook Pro 15" x86_64 (2017)
#
###############################################################
{
  ...
}: {
  imports = [
    #################### Required Configs ####################
    ../common/darwin
    ../common/security
    ../common/optional/yubikey

    #################### Users to Create ####################
    ../common/users/tsunami-darwin
  ];

  networking = {
    hostName = "youmu";
  };
}
