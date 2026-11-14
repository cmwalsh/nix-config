{ ... }:

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
}
