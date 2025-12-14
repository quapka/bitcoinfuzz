{
  stdenvNoCC,
  callPackage,
  lib,
  go_1_24,
  clang
}:
let
  btcd_wrapper = callPackage ./btcd_wrapper { };
  fs = lib.fileset;
  sourceFiles = fs.unions [
    ./.
    ./../../include
    ./../../merge.sh
  ];
in
stdenvNoCC.mkDerivation rec {
  pname = "btcd";
  name = "bitcoinfuzz-${pname}";

  nativeBuildInputs = [
    btcd_wrapper
    clang
    go_1_24
  ];

  src = fs.toSource {
    # We need access to bitcoinfuzz/include files
    root = ./../..;
    fileset = sourceFiles;
  };
  sourceRoot = "${src.name}/modules/btcd";

  configurePhase = ''
    cp ${btcd_wrapper.outPath}/libbtcd_wrapper.a btcd_wrapper/
    chmod +w btcd_wrapper/libbtcd_wrapper.a
  '';

  # Skip the btcd/libbtcd_wrapper.a target because we build it separately
  buildPhase = ''
    make -o btcd/libbtcd_wrapper.a
  '';

  installPhase = ''
    install --preserve-timestamps -D --target-directory $out/modules/${pname}/ module.a
  '';
}
