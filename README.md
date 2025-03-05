# flx-rs
> flx in Rust using dynamic module

The Rust implementation is under [the-flx/flx-rs](https://github.com/the-flx/flx-rs)
; this repo is a fork of [flx-rs](https://github.com/jcs-elpa/flx-rs) packaged as a
Nix flake.

It's a really bad idea to rely on opaque binaries checked into a git repository,
the goal of this fork is to fix that.

It currently supports building for the x86_64-linux and x86_64-windows targets,
PRs adding more targets are welcome.

## 🔨 Setup

### NixOS

Add flake input,

```nix
emacs-flx-rs = {
  url = "github:snyball/emacs-flx-rs";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

Then add it to a `withPackages` invocation:
```nix
let 
  my-emacs = (pkgs.emacs30-pgtk.pkgs.withPackages
    (epkgs: [
      inputs.emacs-flx-rs.defaultPackage.${system}
    ])
  );
in
{
  home.packages = [
    my-emacs
  ]
}
```

### Windows

You can cross-compile this flake for Windows with the following command:

```sh
nix build '.#x86_64-pc-windows-gnu'
```

## Emacs setup

Load in Emacs by calling the following function,

```el
(require 'flx-rs)
(flx-rs-load-dyn)
```

Calculate the score with `PATTERN` and `SOURCE`:

```el
(flx-rs-score "something" "some else thing")
```

## 💥 Replace `flx`

To completely replace `flx` with this package, add the following line to your
configuration.

```el
(advice-add 'flx-score :override #'flx-rs-score)
```

### 🔬 Build

Use the Nix flake, the package will appear in `./result`.

```
$ nix build
```

## ⚜️ License

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.

See [`LICENSE`](./LICENSE.txt) for details.
