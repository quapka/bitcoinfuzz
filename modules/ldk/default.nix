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
  ldk_lib = callPackage ./ldk_lib/default.nix { };
in
stdenvNoCC.mkDerivation rec {
  pname = "ldk";
  name = "bitcoinfuzz-${pname}";

  src = fs.toSource {
    root = ./../..;
    fileset = sourceFiles;
  };
  sourceRoot = "${src.name}/modules/ldk";

  # Make the output of ldk_lib available as expected. In particular,
  # the libldk_lib.a must be writeable otherwise the subsequence calls
  # to `ar` and `ranlib` utilies fail during `merge.sh`
  configurePhase = ''
    mkdir --parents ldk_lib/target/release/
    cp ${ldk_lib.outPath}/lib/libldk_lib.a ldk_lib/target/release/libldk_lib.a
    chmod +w ldk_lib/target/release/libldk_lib.a
  '';

  nativeBuildInputs = [
    clang
    ldk_lib
  ];

  installPhase = ''
    install --preserve-timestamps -D --target-directory $out/modules/${pname} module.a
  '';
}
