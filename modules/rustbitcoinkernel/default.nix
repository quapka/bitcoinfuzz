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
  rustbitcoinkernel_lib = callPackage ./rustbitcoinkernel_lib/default.nix { };
in
stdenvNoCC.mkDerivation rec {
  pname = "rustbitcoinkernel";
  name = "bitcoinfuzz-${pname}";

  src = fs.toSource {
    root = ./../..;
    fileset = sourceFiles;
  };
  sourceRoot = "${src.name}/modules/rustbitcoinkernel";

  # Make the output of rustbitcoinkernel_lib available as expected. In particular,
  # the librustbitcoinkernel_lib.a must be writeable otherwise the subsequence calls
  # to `ar` and `ranlib` utilies fail during `merge.sh`
  configurePhase = ''
    mkdir --parents rustbitcoinkernel_lib/target/release/
    cp ${rustbitcoinkernel_lib.outPath}/lib/librustbitcoinkernel_lib.a rustbitcoinkernel_lib/target/release/librustbitcoinkernel_lib.a
    chmod +w rustbitcoinkernel_lib/target/release/librustbitcoinkernel_lib.a
  '';

  nativeBuildInputs = [
    clang
    rustbitcoinkernel_lib
  ];

  installPhase = ''
    install --preserve-timestamps -D --target-directory $out/modules/${pname}/ module.a
  '';
}
