{lib, pkgs,...}:
{
  programs.helix = {
    enable = true;
    languages = {
      language-server.nix-language-server = with pkgs; [
        nil
      ];
      nix = {
      auto-format = true;
          auto-format-command = "${pkgs.alejandra}/bin/alejandra";
              auto-format-args = "--write";
      };
    };
    settings = {
      # theme = lib.mkDefault "tokyonight_moon";
        editor = {
            line-number = "relative";
            true-color = true;
            auto-format = true;
        };
      };
  };
  home.packages = with pkgs; [
    alejandra
  ];
}
