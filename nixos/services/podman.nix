{ config, ... }:

{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  # The container process must access the AMD GPU device nodes owned by the
  # `render` and `video` groups. Ensure those groups exist (they normally do
  # once `hardware.graphics`/amdgpu is enabled, but declare them defensively).
  users.groups.render = { };
  users.groups.video = { };

  # --- Podman auto-update ---------------------------------------------
  # `podman auto-update` checks containers labelled
  # `io.containers.autoupdate=registry` and pulls + recreates them
  # when the registry has a newer image. Run it weekly via a systemd timer.
  systemd.services.podman-auto-update = {
    description = "Podman auto-update containers";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = [
        "${config.virtualisation.podman.package}/bin/podman auto-update"
      ];
    };
  };

  systemd.timers.podman-auto-update = {
    description = "Podman auto-update timer";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
      RandomizedDelaySec = "1h";
    };
  };
}
