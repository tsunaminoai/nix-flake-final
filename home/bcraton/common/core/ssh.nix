{
  home,
  pkgs,
  ...
}: {
  # Yubikey private key stubs
  home.file.".ssh/id_rsa_yubikey.5cNFC.pub".text = ''
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJxD/U4oHoCyZZfdPLNLEvdch0k2VKbuUJq5r8cKOPvs cardno:24_918_246
  '';
  home.file.".ssh/id_rsa_yubikey.nano5c.pub".text = ''
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAN2yXKnrgQKJDHXqq6lE8v8Olm3theQk2JZ7yTMejwh cardno:23_183 _421
  '';
  programs.ssh = {
    enable = true;
    forwardAgent = true;
    addKeysToAgent = "yes";
    compression = true;
    hashKnownHosts = true;

    matchBlocks = {
      "github.com" = {
        user = "git";
        hostname = "github.com";
        identityFile = [
          "~/.ssh/id_ed25519"
          "~/.ssh/id_rsa_yubikey.5cNFC.pub"
          "~/.ssh/id_rsa_yubikey.nano5c.pub"
          "~/.ssh/id_rsa"
        ];
      };
      "*.gensokyo" = {
        forwardAgent = true;
        identityFile = [
          "~/.ssh/id_rsa_yubikey.5cNFC.pub"
          "~/.ssh/id_rsa_yubikey.nano5c.pub"
        ];
      };
      "pways" = {
        hostname = "100.68.115.114";
        user = "bcraton";
        forwardAgent = false;
        identityFile = "~/.ssh/id_rsa_yubikey.5cNFC.pub";
        identitiesOnly = true;
      };
    };
  };
}
