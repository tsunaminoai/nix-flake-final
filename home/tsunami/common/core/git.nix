{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = lib.mkDefault "TsunamiNoAi";
    userEmail = lib.mkDefault "spam@falseblue.com";
    aliases = {};
    extraConfig = {
      init.defaultBranch = "main";
      url = {
        "ssh://git@github.com" = {
          insteadOf = "https://github.com";
        };
        "ssh://git@gitlab.com" = {
          insteadOf = "https://gitlab.com";
        };
      };

      user.signing.key = "E48B9BA13823B0D8D065C1107467B45313F55526";
      #TODO sops - Re-enable once sops setup complete
      commit.gpgSign = false;
      gpg.program = "${config.programs.gpg.package}/bin/gpg2";
    };
    # enable git Large File Storage: https://git-lfs.com/
    # lfs.enable = true;
    ignores = [".direnv" "result"];
  };
}
