{
  description = "Rustcast";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-root.url = "github:srid/flake-root";
    flake-parts.url = "github:hercules-ci/flake-parts";
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs: inputs.fp.lib.mkFlake { inherit inputs; } {
    systems = inputs.nixpkgs.lib.systems.flakeExposed;
    imports = [
      inputs.flake-root.flakeModule
    ];
    perSystem = { system, config, pkgs, lib, ... }:
      {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = with inputs; [
            devshell.overlays.default
            rust-overlay.overlays.default
          ];
        };
        packages.default = with import nixpkgs { system = "${system}"; };
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

        devShells.default = pkgs.mkShell {
          inputsFrom = [
            config.packages.default
            config.flake-root.devShell
          ];
          buildInputs = with pkgs; [
            gtk4
            pkg-config
          ];
        };
      };
  };
}
