# rustcast

[![crates.io](https://img.shields.io/crates/v/rustcast.svg?style=flat-square&labelColor=black&color=black)](https://crates.io/crates/rustcast)
[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square&labelColor=black&color=black)](./LICENSE)
[![GHA Build Status](https://github.com/ndom91/rustcast/workflows/CI/badge.svg?style=flat-square&labelColor=black&color=black)](https://github.com/ndom91/rustcast/actions?query=workflow%3ACI)


A GTK4 launcher for Linux written in Rust, inspired by [Raycast](https://raycast.com).

## 🛸 Installation

1. TODO

## 🚧 Development

1. Ensure you have rust setup on your machine. If not, you can find rustup [here](https://rustup.rs/).
2. Clone the repository at `https://github.com/ndom91/rustcast`
3. `cargo run`

## ❄ Nix

There is a `flake.nix` with a `package.default`, so you can use this as an input to your own flake if you'd just like to consume this package. If you'd like to develop this on NixOS, the `devshell` there will automatically be activated upon `cd`-ing into the repository's directory if you have `direnv` installed due to the `.envrc` file. This will then allow you to use the commands defined in `devshell.toml`, like `dev` to run the project with `cargo-watch`, and many more.

### 📝 License

MIT
