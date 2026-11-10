{ lib, pkgs,... }:

{
  # Kernel.
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  # Firmware and microcode for the CPU.
  hardware.firmware = [ pkgs.linux-firmware ];
  hardware.cpu.amd.updateMicrocode = true;

  # Enable hardware-accelerated video.
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # needed by Steam and other 32-bit apps
  };

  # Load amdgpu early so it's available for KMS.
  boot.initrd.kernelModules = [ "amdgpu" ];

  # These hosts have no discrete NVIDIA card; only enable the AMD stack.
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Framework 13 has a 2256x1504 display; enable fractional scaling
  # support and a backlight-friendly suspend.
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="acpi_video0", ATTR{brightness}="60"
  '';

  # Power management.
  powerManagement.enable = true;
  services.power-profiles-daemon.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;
}
