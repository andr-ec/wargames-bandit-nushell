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

        packages.docker = pkgs.dockerTools.buildImage {
          name = "bandit-nushell";
          tag = "latest";

          copyToRoot = pkgs.buildEnv {
            name = "bandit-env";
            paths = [
              nushell
              pkgs.coreutils
              pkgs.bash
              pkgs.openssh
              pkgs.openssl
              pkgs.netcat
              pkgs.git
              pkgs.python3
              pkgs.gcc
              pkgs.gnugrep
              pkgs.findutils
              pkgs.gnutar
              pkgs.gzip
              pkgs.bzip2
              self.packages.${system}.default
            ];
            pathsToLink = [ "/bin" "/lib" "/share" ];
          };

          config = {
            Cmd = [ "${nushell}/bin/nu" ];
            WorkingDir = "/game";
            Env = [
              "PATH=/bin"
              "HOME=/root"
            ];
          };

          runAsRoot = ''
            #!${pkgs.runtimeShell}
            mkdir -p /game
            cp -r ${self.packages.${system}.default}/* /game/
          '';
        };

        checks = {
          test-levels = pkgs.runCommand "test-levels" { buildInputs = [ nushell ]; } ''
            mkdir -p $out/bin
            cat > $out/bin/test-levels <<EOF
            #!/bin/sh
            echo "Running level tests..."
            ${nushell}/bin/nushell test-runner.nu
            EOF
            chmod +x $out/bin/test-levels
          '';

          test-levels-25-26 = pkgs.runCommand "test-levels-25-26" { buildInputs = [ nushell ]; } ''
            mkdir -p $out/bin
            cat > $out/bin/test-levels-25-26 <<EOF
            #!/bin/sh
            echo "Running level 25-26 tests..."
            ${nushell}/bin/nushell test-levels-25-26.nu
            EOF
            chmod +x $out/bin/test-levels-25-26
          '';
        };

        apps = {
          default = flake-utils.lib.mkApp {
            drv = pkgs.writeShellScriptBin "play-bandit" ''
              exec ${nushell}/bin/nushell
            '';
          };

          test-levels = flake-utils.lib.mkApp {
            drv = pkgs.writeShellScriptBin "test-levels" ''
              exec ${nushell}/bin/nushell test-runner.nu
            '';
          };

          test-levels-21-24 = flake-utils.lib.mkApp {
            drv = pkgs.writeShellScriptBin "test-levels-21-24" ''
              exec ${nushell}/bin/nushell test-levels-21-24.nu
            '';
          };

          test-levels-25-26 = flake-utils.lib.mkApp {
            drv = pkgs.writeShellScriptBin "test-levels-25-26" ''
              exec ${nushell}/bin/nushell test-levels-25-26.nu
            '';
          };
        };
      }
    );
}
