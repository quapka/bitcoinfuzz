{
  stdenvNoCC,
  clang,
  lib
}:
let
  fs = lib.fileset;
  sourceFiles = fs.unions [
    ./.
    ./../include
  ];
in
stdenvNoCC.mkDerivation rec {
  pname = "custommutator";
  name = "bitcoinfuzz-${pname}";

  src = fs.toSource {
    root = ./..;
    fileset = sourceFiles;
  };
  sourceRoot = "${src.name}/custommutator";

  nativeBuildInputs = [
    clang
  ];

  installPhase = ''
    install --preserve-timestamps -D --target-directory $out/${pname}/ module.a
  '';
}
