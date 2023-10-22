{
  description = "Markus's personal website";

  inputs = {
    flake-utils = {
      url = github:numtide/flake-utils;
    };
    hugo-bearblog = {
      url = github:MarkusPettersson98/hugo-bearblog;
    };
  };

  outputs = { self, nixpkgs, flake-utils, hugo-bearblog, ... }:
    flake-utils.lib.eachSystem [ flake-utils.lib.system.x86_64-linux ]
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        with pkgs;
        rec {
          packages.website = pkgs.stdenv.mkDerivation {
            name = "website";
            src = ./.;
            buildInputs = [ hugo ];
	    configurePhase = ''
              mkdir -p themes
              ln -snf ${hugo-bearblog} themes/bearblog
	    '';
            buildPhase = ''
              hugo
            '';
            installPhase = ''
              cp -r public $out
            '';
          };
	  packages.default = self.packages.${system}.website;
          devShells.default = mkShell { buildInputs = [ nixpkgs-fmt packages.website.buildInputs ]; };
        });
}
