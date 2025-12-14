{
  stdenvNoCC,
  lib,

  clang,

  # modules
  modules
}:
stdenvNoCC.mkDerivation rec {
  pname = "bitcoinfuzz";
  name = "${pname}";

  nativeBuildInputs = [
    clang
  ];

  buildInputs = [
    modules.bitcoin-core
    modules.rustbitcoin
    modules.ldk
    modules.lnd
    modules.btcd
  ];
  
  src = ./.;

  # FIXME deciding what modules are available is quite verbose now
  # concatStringSep
  CXXFLAGS= (if modules.bitcoin-core != null then " -DBITCOIN_CORE" else "")
    + (if modules.rustbitcoin != null then " -DRUST_BITCOIN" else "")
    + (if modules.btcd != null then " -DBTCD" else "")
    + (if modules.ldk != null then " -DLDK" else "")
    + (if modules.lnd != null then " -DLND" else "");

  # FIXME deciding what modules are available is quite verbose now
  configurePhase = lib.concatLines [
    (if modules.bitcoin-core != null then "cp ${modules.bitcoin-core.outPath}/modules/bitcoin/module.a modules/bitcoin/" else "")
    (if modules.rustbitcoin != null then "cp ${modules.rustbitcoin.outPath}/modules/rustbitcoin/module.a modules/rustbitcoin/" else "")
    (if modules.ldk != null then "cp ${modules.ldk.outPath}/modules/ldk/module.a modules/ldk/" else "")
    (if modules.lnd != null then "cp ${modules.lnd.outPath}/modules/lnd/module.a modules/lnd/" else "")
    (if modules.btcd != null then "cp ${modules.btcd.outPath}/modules/btcd/module.a modules/btcd/" else "")
  ];

  installPhase = ''
    install ${pname} --preserve-timestamps -D --target-directory $out/bin/
  '';
}
