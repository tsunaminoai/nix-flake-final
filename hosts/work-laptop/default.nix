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
  ];

  networking = {
    hostName = "MacBook-Pro-0432";
  };
  users.users.bcraton = {
    home = "/Users/bcraton";
    isHidden = false;
    description = "Ben Craton";
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJxD/U4oHoCyZZfdPLNLEvdch0k2VKbuUJq5r8cKOPvs cardno:24_918_246"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAN2yXKnrgQKJDHXqq6lE8v8Olm3theQk2JZ7yTMejwh cardno:23_183_421"
    ];
  };
}
