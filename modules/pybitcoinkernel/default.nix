{
  stdenvNoCC,
  lib,
  python3Packages,

  clang,
}:
let
  py-bitcoinkernel = python3Packages.callPackage ./py-bitcoinkernel.nix { };
  fs = lib.fileset;
  sourceFiles = fs.unions [
    ./.
    ./../../include
  ];
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pybitcoinkernel";
  name = "bitcoinfuzz-${finalAttrs.pname}";

  nativeBuildInputs = [
    clang
  ];

  buildInputs = with python3Packages; [ py-bitcoinkernel ];

  src = fs.toSource {
    root = ./../..;
    fileset = sourceFiles;
  };
  sourceRoot = "${finalAttrs.src.name}/modules/pybitcoinkernel";

  buildPhase = ''
    make -o pybitcoinkernel_lib.py
  '';

  installPhase = ''
    install --preserve-timestamps -D --target-directory $out/modules/${finalAttrs.pname}/ pybitcoinkernel_lib.py
    install --preserve-timestamps -D --target-directory $out/modules/${finalAttrs.pname}/ module.a
  '';
})
