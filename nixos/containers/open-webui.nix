{ config, ... }:

{
  sops.templates."open-webui-env" = {
    content = ''
      OPENAI_API_KEY=${config.sops.placeholder.strata-api-key}
    '';
  };

  systemd.tmpfiles.rules = [
    "d /data/open-webui 0755 root root -"
  ];

  virtualisation.oci-containers = {
    backend = "podman";
    containers.open-webui = {
      image = "ghcr.io/open-webui/open-webui:main";
      autoStart = true;

      ports = [
        "192.168.3.10:3000:8080"
      ];

      volumes = [
        "/data/open-webui:/app/backend/data"
      ];

      environment = {
        # Point Open WebUI at Strata's OpenAI-compatible API (Strata runs on the
        # host and binds 192.168.3.10:8080).
        OPENAI_API_BASE_URL = "http://192.168.3.10:8080/v1";
      };

      # The upstream API key (Strata's key), rendered from sops.
      environmentFiles = [ config.sops.templates."open-webui-env".path ];
    };
  };

  # Ensure the sops-rendered key is available before Open WebUI starts.
  systemd.services."podman-open-webui" = {
    after = [ "sops-install-secrets.service" ];
    requires = [ "sops-install-secrets.service" ];
  };
}
