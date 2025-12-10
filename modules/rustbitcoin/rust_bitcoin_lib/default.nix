{
  lib,
  rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "rust_bitcoin_lib";
  version = "0.1.0";
  name = "bitcoinfuzz-${pname}-${version}";

  src = ./.;

  # FIXME add flags
  # RUSTFLAGS=''
  #   -Z sanitizer=address \
  #   -C passes=sancov-module \
  #   -C llvm-args=-sanitizer-coverage-inline-8bit-counters \
  #   -C llvm-args=-sanitizer-coverage-trace-compares \
  #   -C llvm-args=-sanitizer-coverage-pc-table \
  #   -C llvm-args=-sanitizer-coverage-level=4 \
  #   -C llvm-args=-simplifycfg-branch-fold-threshold=0
  # '';

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "base58ck-0.2.0" = "sha256-IBOcxEusysEOy7txBYi09ytS91gTCP0Y8uYIHcaJYBM=";
    };
  };
}
