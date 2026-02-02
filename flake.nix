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
            echo "Run 'nu' to start the game"
            echo "Level goals are in game/levels/00/goal.txt"
          '';
        };

        packages.default = pkgs.stdenv.mkDerivation {
          pname = "bandit-nushell";
          version = "0.1.0";
          src = ./.;

          buildPhase = ''
            echo "Building Bandit Nushell game..."
            mkdir -p $out/game/levels
            mkdir -p $out/game/data
            mkdir -p $out/game/lib
            cp -r game/levels/* $out/game/levels/
            cp -r game/data/* $out/game/data/
            cp -r game/lib/* $out/game/lib/
            echo "Build complete"
          '';

          installPhase = ''
            mkdir -p $out
          '';

          dontFixup = true;
        };

        # Simple single-user Docker image (direct shell, no auth)
        packages.docker-simple = pkgs.dockerTools.buildImage {
          name = "bandit-nushell-simple";
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
            cp -r ${self.packages.${system}.default}/game/* /game/
          '';
        };

        # SSH-based multi-user Docker image (main experience)
        # This uses a traditional Dockerfile since it needs full Ubuntu with user management
        packages.docker = pkgs.runCommand "bandit-nushell-docker" {
          buildInputs = [ pkgs.docker ];
          src = self;
        } ''
          mkdir -p $out
          echo "To build the SSH-based Nushell Bandit image, run:" > $out/README
          echo "  docker build -t bandit-nushell -f docker/Dockerfile.nushell docker/" >> $out/README
          echo "" >> $out/README
          echo "Or use: nix run .#nushell-bandit" >> $out/README
        '';

        # Original bash version Docker image
        packages.docker-bash = pkgs.dockerTools.buildImage {
          name = "bandit-bash";
          tag = "latest";
          fromImage = pkgs.dockerTools.pullImage {
            imageName = "ubuntu";
            imageDigest = "sha256:b359f1067efa76f37863778f7b6d0e8d911e3ee8bbe4f1f5a7e4a1eb79d2aecd";
            sha256 = "sha256-EfFJL99Dv2bEgNSFZl9ER01pL/MU91A9tjm8CbYDSz8=";
            finalImageName = "ubuntu";
            finalImageTag = "24.04";
          };

          copyToRoot = pkgs.buildEnv {
            name = "bandit-bash-env";
            paths = [
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
              pkgs.xxd
              pkgs.file
            ];
            pathsToLink = [ "/bin" "/lib" "/share" ];
          };

          config = {
            Cmd = [ "${pkgs.bash}/bin/bash" ];
            WorkingDir = "/";
            Env = [
              "PATH=/bin:/usr/bin"
              "HOME=/root"
            ];
            ExposedPorts = { "22/tcp" = {}; };
          };

          runAsRoot = ''
            #!${pkgs.runtimeShell}
            mkdir -p /etc/bandit_pass /etc/bandit_goal /etc/bandit_scripts /etc/bandit_skel
            cp -r ${self}/docker/scripts/* /etc/bandit_scripts/
            cp ${self}/docker/install.sh /install.sh
            chmod +x /install.sh
          '';
        };

        checks = {
          test-levels = pkgs.runCommand "test-levels" { buildInputs = [ nushell ]; } ''
            mkdir -p $out/bin
            cat > $out/bin/test-levels <<EOF
            #!/bin/sh
            echo "Running level tests..."
            ${nushell}/bin/nu tests/test-runner.nu
            EOF
            chmod +x $out/bin/test-levels
          '';
        };

        apps = {
          default = flake-utils.lib.mkApp {
            drv = pkgs.writeShellScriptBin "play-bandit" ''
              exec ${nushell}/bin/nu
            '';
          };

          test = flake-utils.lib.mkApp {
            drv = pkgs.writeShellScriptBin "test-bandit" ''
              exec ${nushell}/bin/nu tests/test-runner.nu
            '';
          };

          # Run original bash bandit via Docker
          bash-bandit = flake-utils.lib.mkApp {
            drv = pkgs.writeShellScriptBin "bash-bandit" ''
              echo "Building and running original bash bandit..."
              if ! command -v docker &> /dev/null; then
                echo "Error: Docker is required to run the bash version"
                exit 1
              fi

              # Build using the Dockerfile
              docker build -t bandit-bash -f ${self}/docker/Dockerfile ${self}/docker

              echo ""
              echo "Starting bandit container on port 2220..."
              docker run -d --name bandit-bash -p 2220:22 bandit-bash:latest

              echo ""
              echo "Connect with: ssh bandit0@localhost -p 2220"
              echo "Password: bandit0"
              echo ""
              echo "To stop: docker stop bandit-bash && docker rm bandit-bash"
            '';
          };

          # Run Nushell bandit via Docker (SSH-based multi-user)
          nushell-bandit = flake-utils.lib.mkApp {
            drv = pkgs.writeShellScriptBin "nushell-bandit" ''
              echo "Building and running Nushell Bandit Wargame..."
              if ! command -v docker &> /dev/null; then
                echo "Error: Docker is required to run the Nushell version"
                exit 1
              fi

              # Stop existing container if running
              docker stop bandit-nushell 2>/dev/null || true
              docker rm bandit-nushell 2>/dev/null || true

              # Build using the Dockerfile.nushell (context is repo root)
              docker build -t bandit-nushell -f ${self}/docker/Dockerfile.nushell ${self}

              echo ""
              echo "Starting Nushell Bandit container on port 2220..."
              docker run -d --name bandit-nushell -p 2220:22 bandit-nushell:latest

              echo ""
              echo "══════════════════════════════════════════════════════════════════"
              echo "  Bandit Wargame - Nushell Edition"
              echo "══════════════════════════════════════════════════════════════════"
              echo ""
              echo "Connect with:"
              echo "  ssh bandit0@localhost -p 2220"
              echo "  Password: bandit0"
              echo ""
              echo "To stop the game:"
              echo "  docker stop bandit-nushell && docker rm bandit-nushell"
              echo ""
            '';
          };
        };
      }
    );
}
