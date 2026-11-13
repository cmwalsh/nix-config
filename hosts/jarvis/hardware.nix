{ lib, pkgs,... }:

{
  # Firmware and microcode for the CPU.
  hardware.firmware = [ pkgs.linux-firmware ];
  hardware.cpu.intel.updateMicrocode = true;

  # Kernel.
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  # Enable hardware-accelerated video.
  hardware.graphics = {
    enable = true;
  };

  # Load amdgpu early so it's available for KMS.
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];
}
