{pkgs, ...}: {
  home.packages = with pkgs; [
    vscode
    shellcheck
    nixfmt
    alejandra
  ];
}
