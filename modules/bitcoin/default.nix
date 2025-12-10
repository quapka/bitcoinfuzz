{
  stdenvNoCC,
  autoconf,
  automake,
  libtool,
  cmake,
  clang,
  lib
}:
let
  fs = lib.fileset;
  sourceFiles = fs.unions [
    ./. # Thanks to the sourceRoot definition later, this adds the ./bitcoinfuzz/modules/bitcoin files
    ./../../include # This adds ./bicoinfuzz/include
  ];
in
stdenvNoCC.mkDerivation rec {
  pname = "bitcoin";
  # The derivation result will be stored in Nix store under <hash>-<name>, thus
  # it's good to reference bitcoinfuzz
  name = "bitcoinfuzz-${pname}";

  src = fs.toSource {
    # We need access to bitcoinfuzz/include files
    root = ./../..;
    fileset = sourceFiles;
  };
  sourceRoot = "${src.name}/modules/bitcoin";

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    clang
    cmake
  ];

  # CMake is needed for ./univalue submodule, but bitcoin itself is not
  # supposed to be built with CMake
  dontUseCmakeConfigure = true;

  # ./modules/bitcoin/Makefile takes care of the complete build, thus we can
  # rely fully on simple `make`
  buildPhase = ''
    make -j $(nproc)
  '';

  # The build artifact is a simple `module.a` file, thus we can simply copy it
  # out of the build context
  installPhase = ''
    mkdir --parents $out/modules/${pname}
    cp module.a $out/modules/${pname}
  '';
}
