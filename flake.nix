{
  description = "Measure the round-trip latency of a soundcard";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ] (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        packages = rec {
          jack_delay = pkgs.callPackage ./jack_delay.nix { };
          default = jack_delay;
        };

        apps.default = utils.lib.mkApp {
          drv = self.packages.${system}.jack_delay;
        };
      }
    ) // {
      overlays.default = final: prev: {
        jack_delay = final.callPackage ./jack_delay.nix { };
      };
    };
}
