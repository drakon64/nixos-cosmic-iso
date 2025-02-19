{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-cosmic,
    }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ];
    in
    {
      legacyPackages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          cosmicIso =
            let
              nixosConfig = nixpkgs.lib.nixosSystem {
                modules = [
                  (
                    {
                      lib,
                      pkgs,
                      modulesPath,
                      ...
                    }:
                    {
                      imports = [
                        nixos-cosmic.nixosModules.default
                        "${modulesPath}/installer/cd-dvd/installation-cd-graphical-base.nix"
                      ];

                      boot = {
                        loader.grub.memtest86.enable = lib.mkForce false;
                        supportedFilesystems.zfs = lib.mkForce false;
                      };

                      isoImage.edition = lib.mkForce "cosmic";
                      nixpkgs.hostPlatform = system;

                      services = {
                        desktopManager.cosmic.enable = true;

                        displayManager = {
                          autoLogin = {
                            enable = true;

                            user = "nixos";
                          };

                          cosmic-greeter.enable = true;
                        };

                        flatpak.enable = true;
                        xserver.excludePackages = [ pkgs.xterm ];
                      };

                      system.stateVersion = lib.trivial.release;
                      virtualisation.virtualbox.guest.enable = lib.mkForce pkgs.stdenv.hostPlatform.isx86;
                    }
                  )
                ];
              };
            in
            nixosConfig.config.system.build.isoImage
            // {
              closure = nixosConfig.config.system.build.isoImage;
              inherit (nixosConfig) config pkgs;
            };
        }
      );
    };
}
