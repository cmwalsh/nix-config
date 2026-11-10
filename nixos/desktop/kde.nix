{ pkgs, ... }:

{
  # Plasma 6 + SDDM (display manager) on Wayland.
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # KDE packages
  environment.systemPackages = with pkgs; [
    kdePackages.filelight
    kdePackages.krdc
    kdePackages.partitionmanager
    kdePackages.isoimagewriter
  ];
}
