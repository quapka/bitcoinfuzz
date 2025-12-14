{
  lib,
  buildDotnetModule,

  dotnetCorePackages,
  clang,
  openssl
}:
let
  fs = lib.fileset;
  sourceFiles = fs.unions [
    ./.
    ./../../include
  ];
in
buildDotnetModule rec {
  pname = "nbitcoin";
  name = "bitcoinfuzz-${pname}";

  dotnet-sdk = dotnetCorePackages.sdk_9_0-bin;
  dotnet-runtime = dotnetCorePackages.runtime_10_0-bin;

  buildInputs = [
    clang
    openssl
  ];


  src = fs.toSource {
    root = ./../..;
    fileset = sourceFiles;
  };
  sourceRoot = "${src.name}/modules/nbitcoin";


  projectFile = "./NBitcoin.CppBridge.csproj"; # must be a string! Not a path, without "
  selfContainedBuild = true;
  nugetDeps = ./deps.json;

  NBITCOIN_LIB_PATH = "./bin/Release/net9.0/linux-x64/native/NBitcoin.CppBridge.so";

  postInstall = ''
    cp ${NBITCOIN_LIB_PATH} ./
    make -o ${NBITCOIN_LIB_PATH} module.a
  '';

  postFixup = ''
    mv $out/lib/${pname}/NBitcoin.CppBridge.so $out/
    chmod +x $out/NBitcoin.CppBridge.so
    install --preserve-timestamps -D --target-directory $out/modules/${pname}/ module.a
  '';

  meta = {
    platforms = lib.intersectLists lib.platforms.x86_64 lib.platforms.linux;
  };
}
