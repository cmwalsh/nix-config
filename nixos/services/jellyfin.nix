{ pkgs-unstable, ... }:

{
  services.jellyfin = {
    enable = true;
    package = pkgs-unstable.jellyfin;
    openFirewall = true;

    hardwareAcceleration = {
      enable = true;
      type = "vaapi";
      device = "/dev/dri/renderD128";
    };

    # Decode the common codecs in hardware.
    transcoding.hardwareDecodingCodecs = {
      h264 = true;
      hevc = true;
      vp9 = true;
      av1 = true;
    };
  };

  # Ensure the Jellyfin media directories exist
  systemd.tmpfiles.rules = [
    "d /ironwolf/media/movies 0755 jellyfin jellyfin -"
    "d /ironwolf/media/tv 0755 jellyfin jellyfin -"
  ];
}
