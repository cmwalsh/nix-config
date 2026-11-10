{ config, pkgs-unstable, ... }:

{
  services.netbird = {
    enable = true;
    package = pkgs-unstable.netbird;
    ui.enable = false;
    useRoutingFeatures = "client";

    clients.default.login = {
      enable = true;
      setupKeyFile = config.sops.secrets.netbird-setup-key.path;
      systemdDependencies = [ "sops-install-secrets.service" ];
    };
  };
}
