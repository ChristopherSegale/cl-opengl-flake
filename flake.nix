{
  description = "Flake for packaging cl-opengl library.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    cl-nix-lite.url = "github:hraban/cl-nix-lite";
    flake-utils.url = "github:numtide/flake-utils";
    cgl = {
      url = "github:3b/cl-opengl";
      flake = false;
    };
  };

  outputs = inputs @ { self, nixpkgs, cl-nix-lite, flake-utils, cgl}:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system}.extend cl-nix-lite.overlays.default;
      inherit (pkgs.lispPackagesLite) lispDerivation;
    in {
      packages = {
        default = lispDerivation {
          src = cgl;
          buildInputs = with pkgs; [
            libGL
          ];
          lispDependencies = with pkgs.lispPackagesLite; [
            cffi
            alexandria
            float-features
          ];
          lispSystem = "cl-opengl";
        };
      };
    });
}
