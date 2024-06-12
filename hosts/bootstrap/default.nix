{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [./disko-config.nix];
  # Kernel parameters I use
  boot.kernelParams = [
    # Disable auditing
    "audit=0"
    # Do not generate NIC names based on PCIe addresses (e.g. enp1s0, useless for VPS)
    # Generate names based on orders (e.g. eth0)
    "net.ifnames=0"
  ];

  # My Initrd config, enable ZSTD compression and use systemd-based stage 1 boot
  boot.initrd = {
    compressor = "zstd";
    compressorArgs = ["-19" "-T0"];
    systemd.enable = true;
  };

  # Install Grub
  boot.loader.grub = {
    enable = !config.boot.isContainer;
    default = "saved";
    devices = ["/dev/vda"];
  };

  # Timezone, change based on your location
  time.timeZone = "America/Los_Angeles";

  # Root password and SSH keys. If network config is incorrect, use this password
  # to manually adjust network config on serial console/VNC.
  users.mutableUsers = false;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH2IrKNs2BLgup7rSVt7KJqRqeSxhU+B1FUrBlHNNmSJ tsunami@youmu"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBm4yzmOrF+MCV+w0yfd10R88iHR6QusZBCpEtPFm+f+ tsunami@mokou"
  ];


  # Manage networking with systemd-networkd
  systemd.network.enable = true;
  services.resolved.enable = false;

  # Configure network IP and DNS
  networking = {
useDHCP = lib.mkDefault true;
  nameservers = [
    "8.8.8.8"
  ];
  firewall.enable = false;
  };
  # Enable SSH server and listen on port 2222
  services.openssh = {
    enable = true;
    ports = [22];
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = lib.mkForce "prohibit-password";
    };
  };

  # Hostname, can be set as you wish
  networking.hostName = "bootstrap";

  # Latest NixOS version on your first install. Used to prevent backward
  # incompatibilities on major upgrades
  system.stateVersion = "23.05";

  # Kernel modules required by QEMU (KVM) virtual machine
  boot.initrd.postDeviceCommands = lib.mkIf (!config.boot.initrd.systemd.enable) ''
    # Set the system time from the hardware clock to work around a
    # bug in qemu-kvm > 1.5.2 (where the VM clock is initialised
    # to the *boot time* of the host).
    hwclock -s
  '';

  boot.initrd.availableKernelModules = [
    "virtio_net"
    "virtio_pci"
    "virtio_mmio"
    "virtio_blk"
    "virtio_scsi"
  ];
  boot.initrd.kernelModules = [
    "virtio_balloon"
    "virtio_console"
    "virtio_rng"
  ];
}
