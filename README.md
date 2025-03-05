[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![JCS-ELPA](https://raw.githubusercontent.com/jcs-emacs/badges/master/elpa/v/flx-rs.svg)](https://jcs-emacs.github.io/jcs-elpa/#/flx-rs)

# flx-rs
> flx in Rust using dynamic module

[![CI](https://github.com/jcs-elpa/flx-rs/actions/workflows/test.yml/badge.svg)](https://github.com/jcs-elpa/flx-rs/actions/workflows/test.yml)
[![Activate](https://github.com/jcs-elpa/flx-rs/actions/workflows/activate.yml/badge.svg)](https://github.com/jcs-elpa/flx-rs/actions/workflows/activate.yml)

[![Build Windows](https://github.com/jcs-elpa/flx-rs/actions/workflows/build_win.yml/badge.svg)](https://github.com/jcs-elpa/flx-rs/actions/workflows/build_win.yml)
[![Build macOS](https://github.com/jcs-elpa/flx-rs/actions/workflows/build_macos.yml/badge.svg)](https://github.com/jcs-elpa/flx-rs/actions/workflows/build_macos.yml)
[![Build Linux](https://github.com/jcs-elpa/flx-rs/actions/workflows/build_linux.yml/badge.svg)](https://github.com/jcs-elpa/flx-rs/actions/workflows/build_linux.yml)

The `rust` implementation is under [the-flx/flx-rs](https://github.com/the-flx/flx-rs)
; hence this repo will only contain releases to ELPA and ready-to-use binary files.

This is a fork to remove the opaque binaries in the git repo.

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
