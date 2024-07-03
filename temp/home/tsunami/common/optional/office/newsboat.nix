{...}: {
  programs.newsboat = {
    enable = true;
    autoReload = true;
    reloadTime = 15;
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
}
