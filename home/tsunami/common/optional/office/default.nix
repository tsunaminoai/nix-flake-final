{pkgs, ...}: {
  home.packages = with pkgs; [
    asciidoctor
    asciigraph
    asciinema
    discordo
    frogmouth
    glow
    hledger
    khal
    neomutt
    pandoc
  ];
}
