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
      inherit (pkgs.lispPackagesLite) lispDerivation lispMultiDerivation cffi alexandria float-features;
      inherit (lispMultiDerivation {
        src = cgl;
        buildInputs = with pkgs; [ libGL libGLU freeglut ];
        systems = {
          cl-opengl = {
            lispDependencies = [ cffi alexandria float-features];
          };
          cl-glu = {
            lispDependencies = [ cffi cl-opengl ];
          };
          cl-glut = {
            lispDependencies = [ alexandria cffi cl-opengl ];
          };
          cl-glut-examples = {
            lispDependencies = [ cffi cl-opengl cl-glu cl-glut ];
          };
        };
      }) cl-opengl cl-glu cl-glut cl-glut-examples;
    in {
      packages = {
        default = cl-opengl;
        inherit cl-glu cl-glut cl-glut-examples;
      };
    });
}
