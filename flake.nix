{
  description = "Bitcoinfuzz";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # NOTE remove flake-utils dependency as we might not be targetting all systems?
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [];
        pkgs = import nixpkgs { inherit system overlays; };

        bitcoinfuzz = pkgs.callPackage ./default.nix { inherit bitcoin-core rustbitcoin; };
        # Build individual modules
        rustbitcoin = pkgs.callPackage ./modules/rustbitcoin { };
        bitcoin-core = pkgs.callPackage ./modules/bitcoin { };
        # TODO is the build of custommutator somehow affected by other chosen modules?
        custommutator = pkgs.callPackage ./custommutator { };

        modules = [
          rustbitcoin
          bitcoin-core
        ];
      in
      with pkgs; {
        # devShells.default = mkShell rec {
        #   buildInputs = [ bitcoinfuzz ] ++ modules;
        # };
        packages = {
          default = bitcoinfuzz;

          inherit bitcoinfuzz custommutator;
          # inherit individual modules
          inherit bitcoin-core rustbitcoin;
        };
      }
    );
}
