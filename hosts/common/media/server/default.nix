rec {
  imports = [
    ./smbclient.nix
    ./kavita.nix
    ./homepage.nix
  ];
  # the config diretory by default is /var/lib/jellyfin/config
  #todo: should this be simply backedup or could we do XML/DB generation from here
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  services.audiobookshelf = {
    enable = true;
    openFirewall = true;
    host = "0.0.0.0";
  };

  #TODO: Definitely cool that this works, but not viable without global backup strat

  # services.borgmatic = {
  #   enable = true;
  #   configurations = {
  #     media-metadata = {
  #       source_directories = [
  #         "/var/lib/jellyfin"
  #         "/var/lib/audiobookshelf"
  #         "/var/lib/kavita"
  #       ];
  #       repositories = [
  #         {
  #           path = "ssh://borgwarehouse@voile.gensokyo:22222/./7e4cca68";
  #           label = "BorgWareHouse@Voile";
  #         }
  #       ];
  #           keep_daily = 7;
  #     };
  #   };
  # };
}
