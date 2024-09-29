{
  description = "Rustcast";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  # outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
  outputs =
    inputs@{ self
    , flake-parts
    , devshell
    , nixpkgs
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        # "aarch64-darwin"
      ];
      imports = [
        devshell.flakeModule
      ];
      perSystem = { system, config, pkgs, lib, ... }:
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = with inputs; [
              devshell.overlays.default
            ];
          };
          packages.default = with import pkgs { system = "${system}"; };
            stdenv.mkDerivation rec {
              name = "rustcast-${version}";
              pname = "rustcast-example";
              version = "0.0.1-20240929";
              src = self;
              buildInputs = rustc.buildInputs ++ [ cargo rustc pkgconfig gtk4 ];
              buildPhase = "cargo build --release";
              installPhase = ''
                mkdir -p $out/bin;
                cp target/release/rustcast $out/bin/rustcast
              '';
            };


          # devshells.default = {
          #   packages = with pkgs; [
          #     gtk4
          #     pkg-config
          #   ];
          # };

          devShells.default = pkgs.devshell.fromTOML ./devshell.toml;
          # devShells.default =
          #   let
          #     llvm = pkgs.llvmPackages_latest;
          #   in
          #   pkgs.devshell.mkShell {
          #     packages = with pkgs; [
          #       llvm.clang
          #       gtk4
          #       pkg-config
          #     ];
          #   };
        };
    };
}

