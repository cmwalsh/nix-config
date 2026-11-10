{ pkgs-unstable, ... }:

{
  services.immich = {
    enable = true;
    package = pkgs-unstable.immich;
    openFirewall = true;

    # This is a dedicated Immich-specific directory
    mediaLocation = "/ironwolf/media/photos/immich";

    # Radeon 890M for transcode + machine-learning (smart search, faces).
    accelerationDevices = [ "/dev/dri/renderD128" ];
  };

  # Ensure the Immich media directory exists
  systemd.tmpfiles.rules = [
    "d /ironwolf/media/photos/immich 0755 immich immich -"
  ];
}
