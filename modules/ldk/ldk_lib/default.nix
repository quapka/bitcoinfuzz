{
  lib,
  rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "ldk_lib";
  version = "0.1.0";
  name = "bitcoinfuzz-${pname}-${version}";

  src = ./.;

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
       "lightning-0.2.0+git" = "sha256-Z77Viwule81l4pZ+Oa5K/HZ9jXxlC/SrpIyhUzSVc+I=";
       "musig2-0.1.0" = "sha256-+ksLhW4rXHDmi6xkPHrWAUdMvkm1cM/PBuJUnTt0vQk=";
    };
  };
}
