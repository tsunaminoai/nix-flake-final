# https://nixos.wiki/wiki/Distributed_build
{
  services.openssh.settings.PermitRootLogin = "prohibit-password";

  boot.binfmt.emulatedSystems = ["x86_64-linux"]; # For cross-compiling
}
