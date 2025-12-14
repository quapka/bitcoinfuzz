{
  lib,
  buildDotnetModule,

  dotnetCorePackages,
  clang
}:
let
  fs = lib.fileset;
  sourceFiles = fs.unions [
    ./. # Thanks to the sourceRoot definition later, this adds the ./bitcoinfuzz/modules/bitcoin files
    ./../../include # This adds ./bicoinfuzz/include
  ];
in
buildDotnetModule rec {
  pname = "nbitcoin";
  name = "bitcoinfuzz-${pname}";

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.runtime_9_0;

  buildInputs = [
    dotnetCorePackages.sdk_9_0
    clang
  ];

  selfContainedBuild = true;

  src = fs.toSource {
    # We need access to bitcoinfuzz/include files
    root = ./../..;
    fileset = sourceFiles;
  };
  sourceRoot = "${src.name}/modules/nbitcoin";
  projectFile = ./NBitcoin.CppBridge.csproj;

  nugetDeps = ./deps.json;

  executables = [ ];
}
