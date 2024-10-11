{outputs, ...}: {
  imports = [
    outputs.homeManagerModules.newsboat
    #################### Required Configs ####################
    ./common/core #required

    #################### Host-specific Optional Configs ####################
    common/optional/sops.nix
    common/optional/dev
    common/optional/neofetch
    common/optional/media
    common/optional/office
    common/optional/editors
  ];

  tsunaminoai.news = {
    enable = true;
    urls = [
      {
        url = "https://cybereason.com/blog/rss.xml";
        tags = ["ciso"];
        title = "Cybereason";
      }
      {
        url = "https://cisomag.com/feed";
        tags = ["ciso"];
        title = "CISO Mag";
      }
      {
        url = "https://cisostreet.com/feed";
        tags = ["ciso"];
        title = "CISO Street";
      }
      {
        url = "https://welivesecurity.com/feed";
        tags = ["security"];
        title = "WeLiveSecurity";
      }
    ];
  };
  # Disable impermanence
  #home.persistence = lib.mkForce { };
  home.homeDirectory = "/Users/tsunami";
}
