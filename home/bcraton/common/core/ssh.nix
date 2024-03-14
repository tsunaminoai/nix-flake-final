{
  home,
  pkgs,
  ...
}: {
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
          "~/.ssh/id_yubikey"
          "~/.ssh/id_ed25519"
          "~/.ssh/id_rsa"
        ];
      };
      "*.gensokyo" = {
        forwardAgent = true;
        identityFile = [
          "~/.ssh/id_yubikey"
          "~/.ssh/id_ed25519"
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
