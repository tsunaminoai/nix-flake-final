{pkgs, ...}: {
  imports = [
    ./vscode.nix
  ];

  home.packages = with pkgs; [
    devbox
    shellcheck
    nixfmt-rfc-style
    alejandra
  ];
}
