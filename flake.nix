{
  description = "Scalable external authorization solution for your software";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        version = "0.49.0";
        commit = if (builtins.hasAttr "rev" self) then self.rev else "unknown";
      in
      {
        packages = rec {
          cerbos = pkgs.buildGo125Module {
            name = "cerbos";

            src = pkgs.fetchFromGitHub {
              owner = "cerbos";
              repo = "cerbos";
              rev = "v${version}";
              # Obtain with `nix flake prefetch github:cerbos/cerbos/v0.49.0`
              sha256 = "sha256-XVK/Y5ml6dp8qq9mPWEidkLSSwwyufbugNjtjdQhgqM=";
            };

            subPackages = [
                "cmd/cerbos"
                "cmd/cerbosctl"
            ];

            env = {
              GOWORK = "off";
              CGO_ENABLED = 0;
            };

            ldflags = [
                "-s -w"
                "-X github.com/cerbos/cerbos/internal/util.Version=${version}-nix"
                "-X github.com/cerbos/cerbos/internal/util.BuildDate=${builtins.toString self.lastModified}"
                "-X github.com/cerbos/cerbos/internal/util.Commit=${commit}"
            ];

            meta = with pkgs.lib; {
                description = "Scalable external authorization solution for your software";
                homepage = "https://cerbos.dev";
                license = licenses.asl20;
                maintainers = with maintainers; [ "charithe" ];
            };

            vendorHash = "sha256-fAvIfVe6OgkUR0021V7NKfuW0kwW7y4ViOjCuULW5ro=";
          };
          default = cerbos;
        };
        apps = rec {
          cerbos = flake-utils.lib.mkApp { drv = self.packages.${system}.cerbos; exePath = "/bin/cerbos"; };
          cerbosctl = flake-utils.lib.mkApp { drv = self.packages.${system}.cerbos; exePath = "/bin/cerbosctl"; };
          default = cerbos;
        };
      }
    );
}
