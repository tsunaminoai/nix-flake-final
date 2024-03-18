{
  pkgs,
  config,
  ...
}: {
  services.xserver.videoDrivers = ["nvidia"];

  environment.variables = {
    ENABLE_VKBASALT = 1;
    GBM_BACKEND = "nvidia-drm";
    WLR_NO_HARDWARE_CURSORS = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  environment.systemPackages = with pkgs; [
    vulkan-loader
    vulkan-validation-layers
    vulkan-tools
  ];

  hardware = {
    nvidia = {
      open = false;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      nvidiaSettings = true;
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    pulseaudio.support32Bit = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      # extraPackages = with pkgs; [
      #   vaapiVdpau
      #   libvdpau-va-gl
      # ];
      extraPackages = with pkgs; [nvidia-vaapi-driver];
    };
  };
}
