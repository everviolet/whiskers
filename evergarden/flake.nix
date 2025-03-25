{
  description = "evergarden crate";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    evergarden-nix.url = "github:everviolet/nix";
    nix-rice.url = "github:bertof/nix-rice";
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      inherit (nixpkgs) lib;

      forAllSystems =
        function: lib.genAttrs lib.systems.flakeExposed (system: function nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forAllSystems (pkgs: {
        default = pkgs.callPackage ./shell.nix {
          evgLib = inputs.evergarden-nix.lib;
          riceLib = inputs.nix-rice.lib.nix-rice;
        };
      });
    };
}
