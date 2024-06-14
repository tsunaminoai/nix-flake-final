{
  ...
}: {
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      aliases = {
        "co" = "pr checkout";
        "ci" = "pr create";
        "pv" = "pr view";
      };
    };
  };
}
