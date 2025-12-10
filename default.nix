{
  stdenvNoCC,
  lib,

  clang,

  # modules
  bitcoin-core ? null,
  rustbitcoin ? null,
}:
stdenvNoCC.mkDerivation rec {
  pname = "bitcoinfuzz";
  name = "${pname}";

  nativeBuildInputs = [
    clang
  ];

  buildInputs = [
    bitcoin-core
    rustbitcoin
  ];
  
  src = ./.;

  # FIXME deciding what modules are available is quite verbose now
  CXXFLAGS= (if bitcoin-core != null then " -DBITCOIN_CORE" else "")
    + (if rustbitcoin != null then " -DRUST_BITCOIN" else "");

  # FIXME deciding what modules are available is quite verbose now
  configurePhase = lib.concatLines [
    (if bitcoin-core != null then "cp ${bitcoin-core.outPath}/modules/bitcoin/module.a modules/bitcoin/" else "")
    (if rustbitcoin != null then "cp ${rustbitcoin.outPath}/modules/rustbitcoin/module.a modules/rustbitcoin/" else "")
  ];

  installPhase = ''
    install ${pname} --preserve-timestamps -D --target-directory $out/bin/
  '';
}
