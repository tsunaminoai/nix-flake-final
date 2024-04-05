# See: https://oddlama.github.io/nix-topology/intro.html
{config, ...}: let
  inherit (config.lib.topology) mkInternet mkSwitch mkConnection;
in {
  nodes.internet = mkInternet {
    connections = mkConnection "yukari" "port-9";
  };
  nodes.yukari = mkSwitch "Yukari" {
    info = "UniFi DreamMachine Pro";
    interfaceGroups = [["port-9"] ["spf-10" "spf-11"]];
    interfaces.spf-10 = {
      network = "gensokyo";
      addresses = ["192.168.0.1/32"];
    };
  };
  nodes.main-switch = mkSwitch "Main Switch" {
    info = "UniFi Switch Pro 24 PoE";
    interfaceGroups = [
      ["port-1" "port-2" "port-3" "port-4"] # voile LAG
      ["port-5" "port-21" "port-22"] # Regular ports
      ["spf-25"] # SFP+ ports
    ];
    connections.spf-25 = mkConnection "yukari" "spf-10";
  };
  nodes.d-link = mkSwitch "Office Switch" {
    info = "Dlink";
    interfaceGroups = [
      ["port-1" "port-2" "port-3" "port-4"] # switch
      ["wan-1"]
    ];
    connections.port-1 = mkConnection "main-switch" "port-5";
    connections.port-4 = mkConnection "mokou" "eth0";
    # any other attributes specified here are directly forwarded to the node:
  };
  nodes.ap-hallway = mkSwitch "Hallway AP" {
    info = "UniFi UAP-AC-Pro";
    interfaceGroups = [
      [
        "port-1"
        "wifi"
      ]
    ];
    connections.port-1 = mkConnection "main-switch" "port-21";
    # any other attributes specified here are directly forwarded to the node:
  };
  nodes.ap-back = mkSwitch "Back AP" {
    info = "UniFi UAP-AC-Pro";
    interfaceGroups = [
      [
        "port-1"
        "wifi"
      ]
    ];
    connections.port-1 = mkConnection "main-switch" "port-22";
    connections.wifi = mkConnection "ap-hallway" "wifi";
    # any other attributes specified here are directly forwarded to the node:
  };
  networks.gensokyo = {
    name = "Gensokyo Home Network";
    cidrv4 = "192.168.0.0/24";
  };
  networks.tailscale = {
    name = "Tailscale Network";
    cidrv4 = "100.0.0.0/8";
  };
}
