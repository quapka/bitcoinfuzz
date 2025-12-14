{
  stdenvNoCC,
  lib,

  clang,

  # modules
  modules
}:
let
    inherit (lib) optionalString concatLines concatStringsSep;
in
stdenvNoCC.mkDerivation rec {
  pname = "bitcoinfuzz";
  name = "${pname}";

  nativeBuildInputs = [
    clang
  ];

  buildInputs = with modules; [
    bitcoin-core
    rustbitcoin
    ldk
    lnd
  ];
  
  src = ./.;

  # FIXME deciding what modules are available is quite verbose now
  # concatStringSep
  CXXFLAGS= with modules; concatStringsSep " " [
    (optionalString (bitcoin-core != null) "-DBITCOIN_CORE")
    (optionalString (rustbitcoin != null) "-DRUST_BITCOIN")
    (optionalString (ldk != null) "-DLDK")
    (optionalString (lnd != null) "-DLND")
    (optionalString (btcd != null) "-DBTCD")
  ];

  # FIXME deciding what modules are available is quite verbose now
  configurePhase = with modules; concatLines [
    (optionalString (bitcoin-core != null) "cp ${bitcoin-core.outPath}/modules/bitcoin/module.a modules/bitcoin/")
    (optionalString (rustbitcoin != null) "cp ${rustbitcoin.outPath}/modules/rustbitcoin/module.a modules/rustbitcoin/")
    (optionalString (ldk != null) "cp ${ldk.outPath}/modules/ldk/module.a modules/ldk/")
    (optionalString (lnd != null) "cp ${lnd.outPath}/modules/lnd/module.a modules/lnd/")
    (optionalString (btcd != null) "cp ${btcd.outPath}/modules/lnd/module.a btcd/lnd/")
  ];

  installPhase = ''
    install ${pname} --preserve-timestamps -D --target-directory $out/bin/
  '';
}
