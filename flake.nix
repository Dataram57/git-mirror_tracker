{
  description = "git-mirror_tracker CLI tool";

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
      in {
        git-mirror_tracker = pkgs.stdenv.mkDerivation {
          pname = "git-mirror_tracker";
          version = "1.0";

          # Script as the source
          src = ./git-mirror_tracker;

          # Ensure git is available
          buildInputs = [ pkgs.git ];

          # Install the script as a command
          installPhase = ''
            mkdir -p $out/bin
            cp $src $out/bin/git-mirror_tracker
            chmod +x $out/bin/git-mirror_tracker
          '';

          meta = with pkgs.lib; {
            description = "CLI tool to track git mirrors";
            license = licenses.mit;
            maintainers = [ maintainers.example ];
          };
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
