{
  buildPythonPackage,
  fetchFromGitHub,
  # build dependencies
  scikit-build-core,
  ninja,
  cmake,
  boost,
}:
buildPythonPackage rec {
  pname = "pybitcoinkernel";
  version = "0.1.0a3";
  name = "${pname}-${version}";
  pyproject = true;

  dependencies = [
    scikit-build-core
  ];

  nativeBuildInputs = [
    ninja
    cmake
  ];

  buildInputs = [
    boost
  ];

  dontUseCmakeConfigure = true;

  src = fetchFromGitHub {
    owner = "stickies-v";
    repo = "py-bitcoinkernel";
    rev = "main";
    hash = "sha256-paEs6ovxXyG4vD4e9Ek/sp8mxDsPAHw1ct1QCmPjrYc=";
  };
}
