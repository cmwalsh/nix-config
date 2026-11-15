{ lib, pkgs, pkgs-unstable, ... }:

{
  home.username = "craig";
  home.homeDirectory = "/home/craig";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    google-chrome
    firefox
    calibre
    sirikali
    proton-vpn
    libreoffice-qt

    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.caskaydia-cove # Cascadia Code
    nerd-fonts.iosevka
  ];

  # Git
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Craig Walsh";
        email = "319043+cmwalsh@users.noreply.github.com";
      };
      init.defaultBranch = "main";
    };
  };

  # Zed editor
  programs.zed-editor = {
    enable = true;
    package = pkgs-unstable.zed-editor;

    userSettings = {
      telemetry = {
        metrics = false;
        diagnostics = false;
      };

      language_models.openai = {
        api_url = "http://192.168.3.10:8080/v1";

        available_models = [
          {
            name = "qwen";
            display_name = "Strata Qwen3.8-Flash-Next";
            max_tokens = 32768;
          }
        ];
      };
    };
  };

  # Mise
  programs.mise = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    globalConfig = {
      settings = {
        # Use prebuilt Node binaries instead of compiling from source
        node.compile = false;
      };

      tools = {
        node = "lts";
        go = "latest";
      };
    };
  };

  # Fish shell
  programs.fish = {
    enable = true;
    functions.fish_greeting = "";
  };

  # Starship prompt
  programs.starship = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      format = lib.concatStrings [
        "$username"
        "@"
        "$hostname"
        " "
        "$directory"
        "$git_branch"
        "$git_status"
        "$character"
      ];

      directory = {
        # Show the full path rather than abbreviating parent directories.
        truncation_length = 0;
        truncate_to_repo = false;
      };

      username = {
        show_always = true;
        format = "[$user]($style)";
      };

      hostname = {
        ssh_only = false;
        format = "[$hostname]($style)";
      };
    };
  };

  # Ghostty
  programs.ghostty = {
    enable = true;

    settings = {
      theme = "Japanesque";
      font-family = "JetBrainsMono Nerd Font";
      term = "xterm-256color";
      window-width = 120;
      window-height = 40;
    };
  };

  # Enable fontconfig discovery so fonts installed via `home.packages` (e.g.
  # the Nerd Font below) are picked up by Ghostty and other apps.
  fonts.fontconfig.enable = true;

  # Let Home Manager manage and version these files
  programs.home-manager.enable = true;
}
