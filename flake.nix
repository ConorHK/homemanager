{
  description = "HomeManager dotfiles flake";

  nixConfig = {
    experimental-features = [
      "flakes"
      "nix-command"
    ];
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    cnvim.url = "github:conorhk/vimrc";
    cnvim.inputs.nixpkgs.follows = "nixpkgs";

    script-directory = {
      url = "github:conorhk/sd";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      flake-utils,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      pkgsForSystem =
        system:
        import nixpkgs {
          overlays = [
            inputs.nur.overlays.default
            outputs.overlays.additions
            outputs.overlays.modifications
            outputs.overlays.unstable-packages
          ];
          inherit system;
        };

      HomeConfiguration =
        args:
        home-manager.lib.homeManagerConfiguration (
          rec {
            modules = [
              (import ./home)
              (import ./modules)
            ];
            extraSpecialArgs = {

            };
            pkgs = pkgsForSystem (args.system or "x86_64-linux");
          }
          // {
            inherit (args) extraSpecialArgs;
          }
        );
    in
    flake-utils.lib.eachSystem
      [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ]
      (system: rec {
        legacyPackages = pkgsForSystem system;
      })
    // {
      overlays = import ./overlays { inherit inputs; };
      homeConfigurations = {
        "dev-dsk" = HomeConfiguration {
          extraSpecialArgs = {
            username = "knoconor";
            role = "dev-dsk";
            system = "x86_64-linux";
            inherit inputs outputs;
          };
        };
        "desktop" = HomeConfiguration {
          extraSpecialArgs = {
            username = "conor";
            role = "desktop";
            system = "x86_64-linux";
            inherit inputs outputs;
          };
        };
      };
    };
}
