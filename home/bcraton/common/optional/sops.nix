# home level sops. see hosts/common/optional/sops.nix for hosts level
# TODO should I split secrtets.yaml into a home level and a hosts level or move to a single sops.nix entirely?
{inputs, ...}: let
  secretspath = builtins.toString inputs.mysecrets;
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    # gnupg = {
    #   home = "/var/lib/sops";
    #   sshKeyPaths = [ ];
    # }

    # This is the ta/dev key and needs to have been copied to this location on the host
    age.keyFile = "/home/tsunami/.config/sops/age/keys.txt";

    defaultSopsFile = "${secretspath}/secrets.yaml";
    validateSopsFiles = false;

    secrets = {
      "taskwarrior/user-cert" = {};
      "taskwarrior/user-key" = {};

      # "private_keys/id_ed25519" = {
      #   path = "/home/tsunami/.ssh/id_ed25519";
      # };
      # "private_keys/id_rsa_yubikey.nano5c" = {
      #   path = "/home/tsunami/.ssh/id_rsa_yubikey.nano5c.ec25519";
      # };
    };
  };
}
