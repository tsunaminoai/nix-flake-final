{pkgs, ...}: {
  home.packages = with pkgs; [
    vscode
    shellcheck
    nixfmt-rfc-style
    alejandra
  ];
}
