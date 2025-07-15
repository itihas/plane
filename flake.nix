{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.compose2nix.url = "github:aksiksi/compose2nix";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, flake-utils, nixpkgs, compose2nix }:
    flake-utils.lib.eachDefaultSystem (system: {
      devShell = nixpkgs.legacyPackages.${system}.mkShell {
        packages = [ compose2nix.packages.${system}.default ];
      };
      nixosModules.plane = ./docker-compose.nix; # generated with compose2nix.
    });
}
