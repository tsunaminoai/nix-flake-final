{
  lib,
  pkgs,
  modulesPath,
  inputs,
  ...
}: let
  inherit (lib) mkDefault;
in {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.disko.nixosModules.disko
  ];

  boot = {
    binfmt.emulatedSystems = ["aarch64-linux"];
    tmp = {
      cleanOnBoot = true;
      useTmpfs = false;
    };

    consoleLogLevel = mkDefault 0;
    kernelPackages = mkDefault pkgs.linuxPackages_latest;
    kernelParams = [
      "psmouse.synaptics_intertouch=1"
      "intel_pstate=disable"
    ];
    extraModprobeConfig = ''
      options i915 enable_fbc=1 enable_guc=2
      options snd_hda_intel enable=0,1 power_save=1 power_save_controller=Y
    '';

    loader = {
      grub = {
        # no need to set devices, disko will add all devices that have a EF02 partition to the list already
        # devices = [ ];
        efiSupport = true;
        efiInstallAsRemovable = true;
      };
      timeout = 3;
    };
    initrd = {
      verbose = false;
      availableKernelModules = [
        "ahci"
        "ehci_pci"
        "sd_mod"
        "uas"
        "usb_storage"
        "usbhid"
        "xhci_pci"
      ];
      kernelModules = [];
    };
    kernelModules = [
      "coretemp"
      # "kvm-intel"
    ];
  };

  # boot.kernelPackages = with pkgs; [
  #   nvidia-x11
  # ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  disko.devices = {
    disk = {
      sda = {
        type = "disk";
        device = "/dev/disk/by-id/wwn-0x5002538e4058ee3d";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              start = "1M";
              end = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              end = "-512M";
              type = "EF02";
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = ["-f"]; # Override existing partition
                # Subvolumes must set a mountpoint in order to be mounted,
                # unless their parent is mounted
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                  };

                  "/persist" = {
                    mountOptions = ["compress=zstd"];
                    mountpoint = "/persist";
                  };

                  "/nix" = {
                    mountOptions = ["compress=zstd" "noatime"];
                    mountpoint = "/nix";
                  };

                  "/swap" = {
                    mountOptions = ["noatime"];
                    mountpoint = "/.swapvol";
                    swap.swapfile.size = "8196M";
                  };
                };
              };
            };
            encryptedSwap = {
              size = "512M";
              content = {
                type = "swap";
                randomEncryption = true;
              };
            };
          };
        };
      };
    };
  };
}
