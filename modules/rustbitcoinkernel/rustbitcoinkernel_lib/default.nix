{
  lib,
  rustPlatform,
  libclang,
  cmake,
  clang,
  boost,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustbitcoinkernel_lib";
  version = "0.1.0";
  name = "${finalAttrs.pname}-${finalAttrs.version}";

  src = ./.;

  # FIXME add flags
  # RUSTFLAGS="\
  # 	-Z sanitizer=address \
  # 	-C passes=sancov-module \
  # 	-C llvm-args=-sanitizer-coverage-inline-8bit-counters \
  # 	-C llvm-args=-sanitizer-coverage-trace-compares \
  # 	-C llvm-args=-sanitizer-coverage-pc-table \
  # 	-C llvm-args=-sanitizer-coverage-level=4 \
  # 	-C llvm-args=-simplifycfg-branch-fold-threshold=0" \
  # cargo +nightly build --release

  nativeBuildInputs = [
    cmake
    clang
  ];

  buildInputs = [
    boost
  ];

  dontUseCmakeConfigure = true;

  cargoHash = "sha256-pxxp5HmY++KhWu4rQHDWyhvtLD9k8glCpnkznhp4L64=";

  LIBCLANG_PATH = lib.makeLibraryPath [ libclang ];
})
