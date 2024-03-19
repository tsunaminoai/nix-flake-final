# Various productivity tools
{pkgs, ...}: {
  imports = [
    ./bitwarden.nix
    ./vscode-server.nix
  ];
  home.packages = with pkgs; [
    remmina # remote desktop client
    libreoffice # office suite
    gimp # image editor
    inkscape # vector graphics editor
    veracrypt # disk encryption
    rpi-imager # raspberry pi image writer
    ventoy-full # image writer
    obsidian # note taking
    tomb # file encryption
  ];

  # Flameshot is a screenshot tool
  services.flameshot = {
    enable = true;
  };
}
