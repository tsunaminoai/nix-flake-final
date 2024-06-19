 {
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
  
}