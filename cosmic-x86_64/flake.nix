{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-cosmic = {
      url = "github:drakon64/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-cosmic }: {
    nixosConfigurations = {
      cosmic = nixpkgs.lib.nixosSystem {
        modules = [
          nixos-cosmic.nixosModules.default
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-base.nix"
          ./configuration.nix
        ];
      };
    };
  };
}
