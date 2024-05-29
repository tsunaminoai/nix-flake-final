{inputs, ...}: {
  imports = [
    inputs.vscode-server.homeModules.default
    ({
      config,
      pkgs,
      ...
    }: {services.vscode-server.enable = true;})
  ];
}
