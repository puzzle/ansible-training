{
  description = "Hugo Docsy-Plus Development Environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            hugo
            nodejs_20
          ];

          shellHook = ''
            echo "Hugo Dev-Shell geladen."
            echo "Hugo Version: $(hugo version)"
            
            # NPM-Pakete für PostCSS/Autoprefixer lokal installieren
            echo "=== Installing npm packages ==="
            npm install postcss postcss-cli autoprefixer
            
            export PATH="$PWD/node_modules/.bin:$PATH"
            
            # Helper function to run check-build
            check-build() {
              set -e

              echo "=== Running npm install ==="
              npm install

              echo "=== Running hugo mod tidy ==="
              hugo mod tidy

              echo "=== Running hugo mod graph ==="
              hugo mod graph

              echo "=== Running hugo --gc --minify build ==="
              hugo --gc --minify 2>&1 | tee build.log

              # Scan output for errors
              if grep -qiE "(error|failed|fatal)" build.log 2>/dev/null; then
                echo "ERRORS detected in build output!"
                exit 1
              else
                echo "Build completed successfully - no errors detected."
                rm -f build.log
              fi
            }
            export -f check-build
          '';
        };
      });
}
