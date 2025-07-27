{
  inputs = { nixpkgs = { url = "github:nixos/nixpkgs/nixpkgs-unstable"; }; };

  outputs = inputs:
    let
      supportedSystems =
        [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f:
        inputs.nixpkgs.lib.genAttrs supportedSystems
        (system: f { pkgs = import inputs.nixpkgs { inherit system; }; });
    in {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            libcxx
            nodejs
            python313
            python313Packages.poetry-core
            poetry
            stdenv.cc.cc
          ];

          shellHook = ''
            export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH"
          '';
        };
      });
    };
}
