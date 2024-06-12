{lib, ...}:{
  nix = {
    settings = {
      builders = lib.mkDefault [
        "ssh://builder@ishtar aarch64-linux x86_64-linux"
        "ssh://builder@mokou aarch64-linux x86_64-linux"
      ];
    };
  };
  
}
