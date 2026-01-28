{
  description = "Nushell Bandit Wargame";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        nushell = pkgs.nushell;
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            nushell
            pkgs.git
            pkgs.openssh
            pkgs.netcat
            pkgs.nmap
            pkgs.gcc
            pkgs.coreutils
            pkgs.findutils
            pkgs.openssl
            pkgs.bash
          ];

          shellHook = ''
            echo "Welcome to Bandit Wargame - Nushell Edition!"
            echo "Run 'nushell' to start the game"
            echo "Level goals are in levels/00/goal.txt"
          '';
        };

        packages.default = pkgs.stdenv.mkDerivation {
          pname = "bandit-nushell";
          version = "0.1.0";
          src = ./.;

          buildPhase = ''
            echo "Building Bandit Nushell game..."
            mkdir -p $out/levels
            mkdir -p $out/data
            mkdir -p $out/lib
            cp -r levels/* $out/levels/
            cp data/* $out/data/
            cp lib/* $out/lib/
            echo "Build complete"
          '';

          installPhase = ''
            mkdir -p $out
          '';

          dontFixup = true;
        };

        checks.test-levels = pkgs.writeShellScriptBin "test-levels" ''
          echo "Running level tests..."
          nushell --test
          echo "Tests complete"
        '';

        apps.test-levels = flake-utils.lib.mkApp {
          drv = pkgs.writeShellScriptBin "test-levels" ''
            echo "Running all level tests..."
            nushell --test
            echo "Test complete"
          '';
        };

        apps.default = flake-utils.lib.mkApp {
          drv = pkgs.writeShellScriptBin "play-bandit" ''
            nushell
          '';
        };
      }
    );
}
