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
        rev = self.rev or self.dirtyRev;
      in
        rec {
          defaultPackage = packages.x86_64-unknown-linux-gnu;
          packages.x86_64-unknown-linux-gnu = naersk-lib.buildPackage {
            pname = "flx-rs";
            ename = "flx-rs";
            src = ./.;
            copyLibs = true;
            nativeBuildInputs = with pkgs; [toolchain];
            postInstall = ''
              dir=$out/share/emacs/site-lisp
              mkdir -p "$dir/lib"
              mv "$out/lib/libflx_rs_core.so" "$dir/lib/flx-rs.x86_64-unknown-linux-gnu.so"
              cp lisp/* "$dir"
              rmdir "$out/bin" "$out/lib"
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
