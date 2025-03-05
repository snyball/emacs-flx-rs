# flx-rs
> flx in Rust using dynamic module

The `rust` implementation is under [the-flx/flx-rs](https://github.com/the-flx/flx-rs)
; this repo is a fork of [flx-rs](https://github.com/jcs-elpa/flx-rs) packaged as a
Nix flake.

It's a really bad idea to rely on opaque binaries checked into a git repository,
the goal of this fork is to fix that.

It currently only supports the x86_64-linux target, but support for aarch linux and
Mac OSX may be added at a later stage.

Support for Windows can also be added, albeit only by cross-compiling with Nix.

## 🔨 Usage

Load by calling the following function,

```el
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
