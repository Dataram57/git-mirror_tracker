{
    description = "git-mirror_tracker";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/master";
    };

    outputs = { self, nixpkgs }:
    let
        systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

        forAllSystems = nixpkgs.lib.genAttrs systems;

    in {
        packages = forAllSystems (system:
        let
            pkgs = import nixpkgs { inherit system; };
        in {
            git-mirror_tracker = pkgs.writeShellApplication {
                name = "git-mirror_tracker";

                # Runtime dependencies
                runtimeInputs = [
                    pkgs.git
                ];

                # The script contents
                text = builtins.readFile ./git-mirror_tracker;

                checkPhase = null;
            };

            default = self.packages.${system}.git-mirror_tracker;
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
