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
        mkLinux = tgt: override: naersk-lib.buildPackage ({
          pname = "flx-rs";
          ename = "flx-rs";
          src = ./.;
          copyLibs = true;
          nativeBuildInputs = with pkgs; [toolchain];
          CARGO_BUILD_TARGET = tgt;
          postInstall = ''
            dir=$out/share/emacs/site-lisp
            mkdir -p "$dir/lib"
            mv "$out/lib/libflx_rs_core.so" "$dir/lib/flx-rs.${tgt}.so"
            cp lisp/* "$dir"
            rm -r "$out/bin" "$out/lib"
          '';
        } // override);
        x86_64-linux = ((import nixpkgs) {
          inherit system;
          crossSystem = {
            config = "x86_64-unknown-linux-gnu";
          };
        });
        aarch64-linux = ((import nixpkgs) {
          inherit system;
          crossSystem = {
            config = "aarch64-unknown-linux-gnu";
          };
        });
      in
        rec {
          defaultPackage = packages.${system};
          packages.x86_64-linux = mkLinux "x86_64-unknown-linux-gnu" {
            depsBuildBuild = [x86_64-linux.stdenv.cc];
            CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER = with x86_64-linux.stdenv;
              "${cc}/bin/${cc.targetPrefix}gcc";
          };
          packages.aarch64-linux = mkLinux "aarch64-unknown-linux-gnu" {
            depsBuildBuild = [aarch64-linux.stdenv.cc];
            CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER = with aarch64-linux.stdenv;
              "${cc}/bin/${cc.targetPrefix}gcc";
          };
          packages.x86_64-windows = naersk-lib.buildPackage rec {
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
            postInstall = ''
              mv "$out/lib/flx_rs_core.dll" "$out/lib/flx-rs.${CARGO_BUILD_TARGET}.dll"
              cp lisp/* "$out"
              rm -r "$out/bin" "$out/lib/libflx_rs_core.dll.a"
            '';
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
