{ ... }:

{
  services.navidrome = {
    enable = true;
    openFirewall = true;

    settings = {
      # Music library on the ZFS pool.
      MusicFolder = "/ironwolf/media/music";

      # Serve on all interfaces so it is reachable from the LAN (relies on the
      # firewall + openFirewall above, which opens the configured Port).
      Address = "0.0.0.0";
      Port = 4533;

      # Keep anonymous usage collection disabled.
      EnableInsightsCollector = false;
    };
  };

  # Ensure the music directory exists
  systemd.tmpfiles.rules = [
    "d /ironwolf/media/music 0755 navidrome navidrome -"
  ];
}
