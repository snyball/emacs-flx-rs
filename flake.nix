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
          file = ./rust-toolchain.toml;
          sha256 = "sha256-AJ6LX/Q/Er9kS15bn9iflkUwcgYqRQxiOIL2ToVAXaU=";
        };
        naersk-lib = naersk.lib.${system}.override {
          cargo = toolchain;
          rustc = toolchain;
        };
        mkInstall = from: to: ''
          dir=$out/share/emacs/site-lisp
          mkdir -p "$dir/lib"
          mv ${from} ${to}
          cp lisp/* "$dir"
          rm -r "$out/bin" "$out/lib"
        '';
      in
        rec {
          defaultPackage = packages.x86_64-unknown-linux-gnu;
          packages.x86_64-unknown-linux-gnu = naersk-lib.buildPackage {
            pname = "flx-rs";
            ename = "flx-rs";
            src = ./.;
            copyLibs = true;
            nativeBuildInputs = with pkgs; [toolchain];
            postInstall = mkInstall
              ''"$out/lib/libflx_rs_core.so"''
              ''"$dir/lib/flx-rs.x86_64-unknown-linux-gnu.so"'';
          };
          packages.x86_64-pc-windows-gnu = naersk-lib.buildPackage rec {
            pname = "flx-rs";
            ename = "flx-rs";
            src = ./.;
            copyLibs = true;
            strictDeps = true;
            depsBuildBuild = with pkgs; [
              pkgsCross.mingwW64.stdenv.cc
              pkgsCross.mingwW64.windows.pthreads
            ];
            nativeBuildInputs = with pkgs; [
              wineWowPackages.stable
              clang
            ];
            CARGO_BUILD_TARGET = "x86_64-pc-windows-gnu";
            postInstall = mkInstall
              ''"$out/lib/flx_rs_core.dll"''
              ''"$dir/lib/flx-rs.${CARGO_BUILD_TARGET}.dll"'';
          };
          devShell = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [
              toolchain
              taplo
            ];
          };
        }
    );
}
