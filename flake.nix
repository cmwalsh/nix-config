{
  description = "A nix flake that defines my homelab infrastructure";

  inputs = {
    # Stable nixpkgs, used by default everywhere.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Unstable nixpkgs, opt-in on a per-package basis.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager, to manage user-level configuration declaratively.
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Disko, for declarative disk partitioning and formatting.
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-flatpak, to declare Flatpak apps/repos instead of installing by hand.
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
    };

    # sops-nix, for declarative secret provisioning (encrypted with age keys).
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, nixpkgs-unstable, home-manager, disko, nix-flatpak, sops-nix, ... }@inputs:
    let

      system = "x86_64-linux";

      pkgs-stable = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

    in
    {
      nixosConfigurations = {
        # Framework 13 laptop (AMD Ryzen 7 7840U)
        defiant = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit inputs;
            pkgs-unstable = pkgs-unstable;
          };

          modules = [
            ./hosts/defiant
            { nixpkgs.pkgs = pkgs-stable; }
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            nix-flatpak.nixosModules.nix-flatpak
            sops-nix.nixosModules.sops
          ];
        };

        # Local AI server (Intel i5-13500 + AMD Radeon RX 9070 XT)
        jarvis = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit inputs;
            pkgs-unstable = pkgs-unstable;
          };

          modules = [
            ./hosts/jarvis
            { nixpkgs.pkgs = pkgs-stable; }
            disko.nixosModules.disko
            sops-nix.nixosModules.sops
          ];
        };
      };
    };
}
