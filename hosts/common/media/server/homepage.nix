{
  services.homepage-dashboard = {
    enable = true;
    openFirewall = true;
    settings = {
      title = "Media Server";
    };
    widgets = [
      {
        resources = {
          cpu = true;
          disk = "/";
          memory = true;
        };
      }
    ];

    services = [
      {
        "Watching" = [
          {
            "Jellyfin" = {
              icon = "jellyfin.svg";
              description = "Anime, Movie, TV, etc";
              href = "http://mokou:8096/";
            };
          }
        ];
      }
      {
        "Reading and Listening" = [
          {
            "AudioBookShelf" = {
              icon = "audiobookshelf.svg";
              description = "Audiobooks";
              href = "http://mokou:8000/";
            };
          }
          {
            "Kavita" = {
              icon = "kavita.svg";
              description = "Books, Light Novels, Manga";
              href = "http://mokou:3000/";
            };
          }
        ];
      }
    ];
  };
}
