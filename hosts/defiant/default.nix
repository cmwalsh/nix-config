{ pkgs, pkgs-unstable, ... }:

{
  imports = [
    ./disk.nix
    ./hardware.nix
    ../../nixos/common
    ../../nixos/common/sops.nix
    ../../nixos/desktop
    ../../nixos/desktop/kde.nix
    ../../nixos/services/ssh.nix
    ../../nixos/services/flatpak.nix
    ../../nixos/services/netbird.nix
  ];

  # Bootloader
  boot = {
    plymouth.enable = true;
    initrd.systemd.enable = true;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # Networking
  networking = {
    hostName = "defiant";
    networkmanager.enable = true;
  };

  # Users
  users.users.craig = {
    isNormalUser = true;
    description = "Craig";
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEN0kjP54K7ilxoulatCxPZBjNxLil01ACy1fn3p6yZy craig@defiant"
    ];
  };

  # Fish shell
  programs.fish = {
    enable = true;
    shellInit = "echo \"\" \n figurine -f \"3d.flf\" defiant; echo \"\"";
  };

  # System packages
  environment.systemPackages = with pkgs; [
    playerctl
    nodejs
    jetbrains.webstorm
    pkgs-unstable.netbird-ui
  ];

  # System programs
  programs = {
    nix-ld.enable = true;
    gamescope.enable = true;
    direnv.enable = true;
  };

  # Flatpaks
  services.flatpak.packages = [
    "md.obsidian.Obsidian" # Obsidian
    "fm.reaper.Reaper" # Reaper
    "org.musicbrainz.Picard" # Picard
    "com.spotify.Client" # Spotify
    "org.kde.haruna" # Haruna
    "fr.handbrake.ghb" # Handbrake
    "org.jeffvli.feishin" # Feishin
    "org.freeorion.FreeOrion" # FreeOrion
    "io.github.zerospades.ZeroSpades" # ZeroSpades
    "com.shatteredpixel.shatteredpixeldungeon" # Shattered Pixel Dungeon
    "org.signal.Signal" # Signal desktop
  ];

  # Secrets
  sops.secrets.netbird-setup-key = {
    key = "netbird_setup_key_workstation";
  };

  # Home manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit pkgs-unstable; };
    users.craig = import ./home.nix;
  };
}
