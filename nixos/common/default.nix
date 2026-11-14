{ pkgs, ... }:

{
  # Nix and Nix Packages
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  # Locale
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "uk";
  services.xserver.xkb.layout = "gb";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Avahi (mDNS)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish.enable = true;
    publish.userServices = true;
    openFirewall = true;
  };

  # Common system packages
  environment = {
    systemPackages = with pkgs; [
      wget
      curl
      git
      btop
      ripgrep
      fd
      jq
      vim
      micro
      fresh-editor
      marksman
      nixd
      nil
      nixpkgs-fmt
      gocryptfs
      figurine
      sops
      age
      ssh-to-age

      # Common Linux diagnostic / utility tools.
      pciutils          # lspci — enumerate PCI(e) devices
      usbutils          # lsusb — enumerate USB devices
      lshw              # lshw — detailed hardware inventory
      inxi              # inxi — consolidated system/hardware summary
      util-linux        # lsblk, blkid, fdisk, dmesg, etc.
      procps            # ps, top, free, vmstat, pidof, etc.
      kmod              # lsmod, modprobe, modinfo — kernel modules
      iproute2          # ip, ss — network interface/routing/socket tools
      ethtool           # ethtool — NIC/link diagnostics
      dmidecode         # dmidecode — BIOS/board/memory info (DMI)
      smartmontools     # smartctl — SMART disk health + tests
      hdparm            # hdparm/sdparm — disk param & benchmark
      ncdu              # ncdu — interactive disk usage (NCurses)
      dust              # dust (formerly du-dust) — fast disk usage overview
      file              # file — identify file types
      tree              # tree — directory listing
      lsof              # lsof — list open files (already in coreutils? keep explicit)
      strace            # strace — syscall tracing
      tcpdump           # tcpdump — packet capture
      dnsutils          # dig, nslookup, host — DNS lookups
      unzip             # unzip/zip — archive handling
      zip
      gzip
      unar              # unar/lsar — extract many archive formats
      rsync             # rsync — file sync/copy
      openssh           # ssh, scp, sftp client
      coreutils-full    # full coreutils (e.g. numfmt, tsort, etc.)
      gnused
      gnugrep
      gawk
      findutils
      which
      openssl
    ];

    variables = {
      EDITOR = "micro";
      SYSTEMD_EDITOR = "micro";
      VISUAL = "micro";
    };
  };

  # Don't change this!
  system.stateVersion = "26.05";
}
