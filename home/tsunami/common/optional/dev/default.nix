{pkgs, ...}: {
  imports = [
    ./vscode.nix
    ./network-tools.nix
  ];

  home.packages = with pkgs; [
    devbox
    shellcheck
    nixfmt-rfc-style
    alejandra
  ];
}
