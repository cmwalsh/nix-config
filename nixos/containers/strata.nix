{ config, ... }:

{
  # The Strata API key, rendered as an env file (`API_KEY=...`) from the sops
  # `strata_api_key` secret. `environmentFiles` below passes it to the container
  # via `--env-file`, keeping the key out of the Nix store and process list.
  sops.templates."strata-env" = {
    content = ''
      API_KEY={{ .strata_api_key }}
    '';
  };

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
        "/models/strata:/data"
      ];

      environment = {
        FAMILY = "qwen";
        MODEL = "IQ3_XXS";
      };

      environmentFiles = [
        config.sops.templates."strata-env".path
      ];

      extraOptions = [
        "--group-add" "video"
        "--group-add" "render"
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
}
