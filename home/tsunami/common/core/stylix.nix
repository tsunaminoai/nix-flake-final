{
  pkgs,
  config,
  ...
}: let
  image = config.lib.stylix.pixel "base0A";
in {
  # See [Docs](../docs/README.md#using-stylix-and-base16)
  stylix = {
    image = image;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
  };
}
