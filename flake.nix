{
    description = "git-mirror_tracker - Tool for tracking git repositories.";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    outputs = { self, nixpkgs }:
    let
        systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
        forAllSystems = nixpkgs.lib.genAttrs systems;
    in{
        packages = forAllSystems (system:
            let
                pkgs = import nixpkgs { inherit system; };
            in{
                git-mirror_tracker = pkgs.stdenv.mkDerivation {
                    pname = "git-mirror_tracker";
                    version = "1.0";

                    src = ./git-mirror_tracker;

                    buildInputs = [ pkgs.makeWrapper pkgs.git ];

                    unpackPhase = ":";  # skip unpack

                    installPhase = ''
                        mkdir -p $out/bin
                        cp $src $out/bin/git-mirror_tracker
                        chmod +x $out/bin/git-mirror_tracker

                        # Wrap the script so git is in PATH
                        wrapProgram $out/bin/git-mirror_tracker \
                            --prefix PATH : "${pkgs.git}/bin"
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
