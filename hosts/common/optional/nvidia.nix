{
  pkgs,
  config,
  ...
}: {
  environment = {
    sessionVariables = {
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      NIXOS_OZONE_WL = "1"; # https://github.com/NixOS/nixpkgs/issues/224332#issuecomment-1528748548

      WLR_DRM_NO_ATOMIC = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
      LIBVA_DRIVER_NAME = "nvidia";
      MOZ_DISABLE_RDD_SANDBOX = "1";
      EGL_PLATFORM = "wayland";
    };

    systemPackages = with pkgs; [
      vulkan-loader
      vulkan-validation-layers
      vulkan-tools
      nvtopPackages.full
    ];
  };

  hardware = {
    nvidia = {
      open = false;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      nvidiaSettings = true;
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };
  boot.kernelParams = ["module_blacklist=i915"];
  boot.initrd.kernelModules = ["nvidia"];
  services.xserver.videoDrivers = ["nvidia"];
}
