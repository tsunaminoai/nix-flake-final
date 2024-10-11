{
  home,
  config,
  ...
}: {
  home.file.".ssh/id_5cNFC.pub".source = ./keys/id_5cNFC.pub;
  home.file.".ssh/id_nano5c.pub".source = ./keys/id_nano5c.pub;

  programs.ssh = {
    enable = true;
    forwardAgent = true;
    addKeysToAgent = "yes";
    compression = true;
    hashKnownHosts = true;

    matchBlocks = {
      "ssh.dev.azure.com" = {
        user = "git";
        hostname = "ssh.dev.azure.com";
        identitiesOnly = true;
        identityFile = [
          # ADO only supports RSA keys >.>
          "~/.ssh/id_rsa"
        ];
      };
      "github.com" = {
        user = "git";
        hostname = "github.com";
        identitiesOnly = true;
        identityFile = [
          config.sops.secrets."github/ssh-key".path

          "~/.ssh/id_yubikey.pub"
          "~/.ssh/id_ed25519"
          "~/.ssh/id_rsa"
        ];
      };
      "*.gensokyo" = {
        forwardAgent = true;
        identityFile = [
          "~/.ssh/id_yubikey.pub"
          "~/.ssh/id_ed25519"
        ];
      };
      "*.armadillo-banfish.ts.net" = {
        forwardAgent = true;
        identityFile = [
          "~/.ssh/id_yubikey.pub"
          "~/.ssh/id_ed25519"
        ];
      };
      "pways" = {
        hostname = "100.68.115.114";
        user = "bcraton";
        forwardAgent = false;
        identityFile = "~/.ssh/id_yubikey.pub";
        identitiesOnly = true;
      };
    };
  };
}
