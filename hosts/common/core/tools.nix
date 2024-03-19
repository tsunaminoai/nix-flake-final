# Common cli tools for system administration
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    glances
    git
    dust
    tldr
    fd
    rsync
    fzf
    mosh
    htop
    progress
    pstree
    ripgrep
    spark
    xz
    wakeonlan
    watchexec
    speedtest-cli
    bandwhich
    nano
    curl
    wget
    jq
    uutils-coreutils-noprefix
    btrfs-progs
    cifs-utils
    appimage-run
  ];
}
