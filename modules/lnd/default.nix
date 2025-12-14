{
  stdenvNoCC,
  callPackage,
  lib,
  go_1_24,
  clang
}:
let
  lnd = callPackage ./lnd_wrapper { };
  fs = lib.fileset;
  sourceFiles = fs.unions [
    ./.
    ./../../include
    ./../../merge.sh
  ];
in
stdenvNoCC.mkDerivation rec {
  pname = "lnd";
  name = "bitcoinfuzz-${pname}";

  nativeBuildInputs = [
    lnd
    clang
    go_1_24
  ];

  src = fs.toSource {
    # We need access to bitcoinfuzz/include files
    root = ./../..;
    fileset = sourceFiles;
  };
  sourceRoot = "${src.name}/modules/lnd";

  configurePhase = ''
    cp ${lnd.outPath}/liblnd_wrapper.a lnd_wrapper/
    chmod +w lnd_wrapper/liblnd_wrapper.a
  '';

  buildPhase = ''
    make -o golang
  '';

  installPhase = ''
    install --preserve-timestamps -D --target-directory $out/modules/${pname}/ module.a
  '';
}
