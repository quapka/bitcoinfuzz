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

        bitcoinfuzz = pkgs.callPackage ./default.nix { inherit modules; };

        # Build individual modules
        btcd = pkgs.callPackage ./modules/btcd/default.nix { };
        rustbitcoin = pkgs.callPackage ./modules/rustbitcoin { };
        bitcoin-core = pkgs.callPackage ./modules/bitcoin { };
        ldk = pkgs.callPackage ./modules/ldk { };
        lnd = pkgs.callPackage ./modules/lnd { };
        nbitcoin = pkgs.callPackage ./modules/nbitcoin { };
        # TODO is the build of custommutator somehow affected by other chosen modules?
        custommutator = pkgs.callPackage ./custommutator { };

        modules = {
          inherit
          rustbitcoin
          bitcoin-core
          btcd
          ldk
          lnd;
          nbitcoin;
        };
      in
      with pkgs; {
        # devShells.default = mkShell rec {
        #   buildInputs = [ bitcoinfuzz ] ++ modules;
        # };
        packages = {
          default = bitcoinfuzz;

          inherit bitcoinfuzz custommutator;
          # inherit individual modules
          inherit modules;
        };
      }
    );
}
