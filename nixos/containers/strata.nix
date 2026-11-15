{ config, ... }:

{
  sops = {
    secrets.strata-api-key = {
      sopsFile = ../../secrets/jarvis.yaml;
      key = "strata_api_key";
    };

    templates."strata-env" = {
      content = ''
        API_KEY=${config.sops.placeholder.strata-api-key}
      '';
    };
  };

  systemd.tmpfiles.rules = [
    "d /data/strata 0755 root root -"
  ];

  virtualisation.oci-containers = {
    backend = "podman";

    containers.strata = {
      image = "ghcr.io/niko1221/strata:0.2.7-rocm-gfx120x";
      autoStart = true;

      # AMD GPU passthrough (ROCm KFD + DRM render nodes).
      devices = [
        "/dev/kfd:/dev/kfd"
        "/dev/dri:/dev/dri"
      ];

      ports = [
        "192.168.3.10:8080:8080"
      ];

      volumes = [
        "/data/strata:/data"
      ];

      environment = {
        FAMILY = "qwen";
        MODEL = "IQ3_XXS";
      };

      environmentFiles = [
        config.sops.templates."strata-env".path
      ];

      extraOptions = [
        "--group-add" (toString config.users.groups.video.gid)
        "--group-add" (toString config.users.groups.render.gid)
        "--ulimit" "memlock=-1:-1"
        "--shm-size" "2g"
        "--stop-timeout" "120"
      ];
    };
  };

  # Ensure the sops template (and thus the API key) has been written before the
  # container starts. The oci-containers unit is named `podman-strata.service`.
  systemd.services."podman-strata" = {
    after = [ "sops-install-secrets.service" ];
    requires = [ "sops-install-secrets.service" ];
  };

  # Allow the Strata API (port 8080) from the LAN.
  networking.firewall.allowedTCPPorts = [ 8080 ];
}
