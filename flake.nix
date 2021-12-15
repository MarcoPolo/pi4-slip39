{
  description = "Flake to build a Raspberry Pi 4 image with Slip39 binaries";
  inputs.nixos.url = "github:nixos/nixpkgs/release-21.11";
  inputs.slip39-python.url = "path:./slip39-python";
  inputs.slip39-rust.url = "github:marcopolo/slip39-rust";

  outputs = { self, nixos, slip39-python, slip39-rust }: {
    nixosConfigurations =
      {
        # Build the SD Card image with:
        # nix build .#nixosConfigurations.shamirPi.config.system.build.sdImage
        shamirPi = nixos.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            (
              { config, pkgs, lib, modulesPath, ... }:
                {

                  imports = [
                    (modulesPath + "/installer/sd-card/sd-image-aarch64-installer.nix")
                  ];
                  environment.systemPackages = [
                    # Binary is called `shamir`
                    slip39-python.defaultPackage."aarch64-linux"
                    # Binary is called `slip39`
                    slip39-rust.defaultPackage."aarch64-linux"
                  ];
                }
            )
          ];
        };
      };
  };
}
