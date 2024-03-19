{
  home,
  pkgs,
  config,
  ...
}: {
  home.file.".ssh/id_5cNFC.pub".source = ./keys/id_5cNFC.pub;
  home.file.".ssh/id_nano5c.pub".source = ./keys/id_nano5c.pub;

  programs.ssh = {
    enable = true;
    forwardAgent = true;
    # addKeysToAgent = "yes";
    compression = true;
    hashKnownHosts = true;

    matchBlocks = {
      "github.com" = {
        user = "git";
        hostname = "github.com";
        identityFile = [
          config.sops.secrets."github/ssh-key".path

          "~/.ssh/id_ed25519"
          "~/.ssh/id_yubikey"
          "~/.ssh/id_rsa"
        ];
      };
      "*.gensokyo" = {
        forwardAgent = true;
        identityFile = [
          "~/.ssh/id_ed25519"
          "~/.ssh/id_yubikey"
        ];
      };
      "*.armadillo-banfish.ts.net" = {
        forwardAgent = true;
        identityFile = [
          "~/.ssh/id_ed25519"
          "~/.ssh/id_yubikey"
        ];
      };
      "pways" = {
        hostname = "100.68.115.114";
        user = "bcraton";
        forwardAgent = false;
        identityFile = "~/.ssh/id_yubikey";
        identitiesOnly = true;
      };
    };
  };
}
