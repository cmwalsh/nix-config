{ ... }:

{
  services.flatpak = {
    enable = true;

    update = {
      onActivation = false;
      auto = {
        enable = true;
        onCalendar = "weekly";
      };
    };

    uninstallUnmanaged = true;
  };

  # Expose the Flatpak-managed exports (.desktop files, icons, dbus/gir) to the
  # desktop session. nix-flatpak installs apps system-wide but does NOT add
  # `/var/lib/flatpak/exports` to `XDG_DATA_DIRS` (unlike the built-in
  # `services.flatpak`), so without this the app menu never sees installed apps
  environment.profiles = [
    "/var/lib/flatpak/exports"
    "$HOME/.local/share/flatpak/exports"
  ];

  environment.pathsToLink = [
    "/share/applications"
    "/share/icons"
    "/share/metainfo"
    "/share/dbus-1"
  ];
}
