{ pkgs, ... }:

{
  imports = [
    ./disk.nix
    ./hardware.nix
    ../../nixos/common
    ../../nixos/common/sops.nix
    ../../nixos/services/ssh.nix
    # ../../nixos/services/netdata.nix
    ../../nixos/containers/strata.nix
  ];

  # Bootloader
  boot = {
    initrd.systemd.enable = true;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # Networking
  networking = {
    hostName = "jarvis";

    networkmanager = {
      enable = true;

      ensureProfiles = {
        profiles.lan = {
          connection = {
            id = "lan";
            type = "ethernet";
            autoconnect = true;
          };

          ethernet = {
            mac-address = "74:56:3c:29:dd:6d";
          };

          ipv4 = {
            method = "manual";
            addresses = "192.168.3.10/24";
            gateway = "192.168.3.1";
            dns = "192.168.3.1;";
          };

          ipv6 = {
            method = "disabled";
          };
        };
      };
    };
  };

  # Users
  users.users.sysadmin = {
    isNormalUser = true;
    description = "System Administrator";
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEN0kjP54K7ilxoulatCxPZBjNxLil01ACy1fn3p6yZy craig@defiant"
    ];
  };

  # Fish shell
  programs.fish = {
    enable = true;
    shellInit = "echo \"\" \n figurine -f \"3d.flf\" jarvis; echo \"\"";
  };

  # System packages
  environment.systemPackages = with pkgs; [
    amdgpu_top
    radeontop
    btop
    lm_sensors
  ];

  # System programs
  programs = {
    nix-ld.enable = true;
  };

  # Secrets
  # sops.secrets.netbird-setup-key = {
  #   key = "netbird_setup_key_workstation";
  # };
}
