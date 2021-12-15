{
  description = "A very basic flake";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.slip39-python = {
    url = "github:trezor/python-shamir-mnemonic";
    flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, slip39-python }:
    flake-utils.lib.eachDefaultSystem (
      system:
        let
          pkgs = import nixpkgs { system = system; };
        in
          {
            packages.hello = pkgs.hello;
            defaultPackage =
              with pkgs.python3Packages;
              buildPythonApplication {
                pname = "slip39-python";
                version = "1.0";

                propagatedBuildInputs = [ attrs click colorama pytest ];

                src = slip39-python;
              };
            devShell = pkgs.mkShell {
              buildInputs = [ pkgs.hello ];
            };
          }
    );
}
