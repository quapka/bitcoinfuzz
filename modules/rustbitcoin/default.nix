{
  stdenvNoCC,
  lib,
  clang,
  callPackage
}:
let
  fs = lib.fileset;
  sourceFiles = fs.unions [
    ./.
    ./../../include
    ./../../merge.sh
  ];
  rust_bitcoin_lib = callPackage ./rust_bitcoin_lib/default.nix { };
in
stdenvNoCC.mkDerivation rec {
  pname = "rustbitcoin";
  name = "bitcoinfuzz-${pname}";

  src = fs.toSource {
    root = ./../..;
    fileset = sourceFiles;
  };
  sourceRoot = "${src.name}/modules/rustbitcoin";

  # Make the output of rust_bitcoin_lib available as expected. In particular,
  # the librust_bitcoin_lib.a must be writeable otherwise the subsequence calls
  # to `ar` and `ranlib` utilies fail during `merge.sh`
  configurePhase = ''
    mkdir --parents rust_bitcoin_lib/target/release/
    cp ${rust_bitcoin_lib.outPath}/lib/librust_bitcoin_lib.a rust_bitcoin_lib/target/release/librust_bitcoin_lib.a
    chmod +w rust_bitcoin_lib/target/release/librust_bitcoin_lib.a
  '';

  nativeBuildInputs = [
    clang
    rust_bitcoin_lib
  ];

  installPhase = ''
    install --preserve-timestamps -D --target-directory $out/modules/${pname}/ module.a
  '';
}
