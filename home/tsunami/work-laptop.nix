{
  pkgs,
  outputs,
  ...
}: {
  imports = [
    outputs.homeManagerModules.newsboat
    outputs.homeManagerModules.razer-mouse
    #################### Required Configs ####################
    ./common/core #required

    #################### Host-specific Optional Configs ####################
    common/optional/sops.nix

    #################### Optional Configs ####################
    common/optional/editors
    common/optional/dev
  ];
  # Disable impermanence
  #home.persistence = lib.mkForce { };

  # Overrides for work
  home = {
    homeDirectory = "/Users/bcraton";
    username = "bcraton";
  };

  tsunaminoai = {
    razer-mouse.enable = true;
    news = {
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
  };

  programs.git = {
    userName = "Ben Craton";
    userEmail = "bcraton@passageways.com";
  };
}
