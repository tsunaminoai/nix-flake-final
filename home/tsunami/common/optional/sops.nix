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
    age.keyFile = builtins.toPath "/Users/tsunami/Library/Application Support/sops/age/keys.txt";

    defaultSopsFile = "${secretspath}/secrets.yaml";
    validateSopsFiles = false;

    secrets = {
      "taskwarrior/user-cert" = {
        path = "/Users/tsunami/.task/cert.pem";
      };
      "taskwarrior/user-key" = {
        path = "/Users/tsunami/.task/key.pem";
      };

      # "private_keys/id_ed25519" = {
      #   path = "/home/tsunami/.ssh/id_ed25519";
      # };
      # "private_keys/id_rsa_yubikey.nano5c" = {
      #   path = "/home/tsunami/.ssh/id_rsa_yubikey.nano5c.ec25519";
      # };
    };
  };
}
