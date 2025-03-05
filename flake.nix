{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    naersk = {
      url = github:nmattia/naersk;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = github:nix-community/fenix;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = github:numtide/flake-utils;
  };

  outputs = { self, nixpkgs, naersk, fenix, flake-utils }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        manifest = (pkgs.lib.importTOML ./Cargo.toml).package;
        toolchain = fenix.packages.${system}.fromToolchainFile {
          file = ./core/rust-toolchain.toml;
          sha256 = "sha256-vMlz0zHduoXtrlu0Kj1jEp71tYFXyymACW8L4jzrzNA=";
        };
        naersk-lib = naersk.lib.${system}.override {
          cargo = toolchain;
          rustc = toolchain;
        };
        build-deps = with pkgs; [toolchain];
        rev = self.rev or self.dirtyRev;
      in
        rec {
          defaultPackage = packages.x86_64-unknown-linux-gnu;
          packages.x86_64-unknown-linux-gnu = naersk-lib.buildPackage {
            src = ./core;
            nativeBuildInputs = build-deps;
          };
          devShell = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [
              taplo
            ] ++ build-deps;
          };
        }
    );
}
