{
  stdenvNoCC,
  lib,

  clang,

  # modules
  bitcoin-core ? null,
  rustbitcoin ? null,
  ldk ? null,
  lnd ? null,
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
    ldk
    lnd
  ];
  
  src = ./.;

  # FIXME deciding what modules are available is quite verbose now
  CXXFLAGS= (if bitcoin-core != null then " -DBITCOIN_CORE" else "")
    + (if rustbitcoin != null then " -DRUST_BITCOIN" else "")
    + (if ldk != null then " -DLDK" else "")
    + (if lnd != null then " -DLND" else "");

  # FIXME deciding what modules are available is quite verbose now
  configurePhase = lib.concatLines [
    (if bitcoin-core != null then "cp ${bitcoin-core.outPath}/modules/bitcoin/module.a modules/bitcoin/" else "")
    (if rustbitcoin != null then "cp ${rustbitcoin.outPath}/modules/rustbitcoin/module.a modules/rustbitcoin/" else "")
    (if ldk != null then "cp ${ldk.outPath}/modules/ldk/module.a modules/ldk/" else "")
    (if lnd != null then "cp ${lnd.outPath}/modules/lnd/module.a modules/lnd/" else "")
  ];

  installPhase = ''
    install ${pname} --preserve-timestamps -D --target-directory $out/bin/
  '';
}
