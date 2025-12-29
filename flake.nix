{
  description = "git-mirror_tracker CLI tool with wrapper";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in
  {
    packages = forAllSystems (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        git-mirror_tracker = pkgs.stdenv.mkDerivation {
          pname = "git-mirror_tracker";
          version = "1.0";

          # Script is source
          src = ./git-mirror_tracker;

          # Build dependencies
          buildInputs = [ pkgs.makeWrapper pkgs.git ];

          # Skip unpacking since it's a single file
          unpackPhase = ":";

          # Install phase: use makeWrapper to set PATH
          installPhase = ''
            mkdir -p $out/bin
            cp $src $out/bin/git-mirror_tracker.orig
            chmod +x $out/bin/git-mirror_tracker.orig

            # Wrap the script so git is in PATH
            wrapProgram $out/bin/git-mirror_tracker.orig \
              --prefix PATH : "${pkgs.git}/bin" \
              --set SCRIPT "$out/bin/git-mirror_tracker.orig" \
              --run-command '$SCRIPT "$@"' \
              --suffix "-wrapper"
            
            # Symlink wrapper to final name
            mv $out/bin/git-mirror_tracker.orig-wrapper $out/bin/git-mirror_tracker
          '';
        };
      }
    );

    apps = forAllSystems (system: {
      git-mirror_tracker = {
        type = "app";
        program = "${self.packages.${system}.git-mirror_tracker}/bin/git-mirror_tracker";
      };
      default = self.apps.${system}.git-mirror_tracker;
    });
  };
}
