{
  stdenvNoCC,
  lib,

  clang,
  openssl,
  pkg-config,
  makeWrapper,
  python3,

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
    makeWrapper
  ];

  buildInputs = with modules; [
    bitcoin-core
    rustbitcoin
    rustbitcoinkernel
    pybitcoinkernel
    ldk
    lnd
    btcd
    nbitcoin
    python3
  ];

  runtimeLibDeps = [
    modules.nbitcoin
    openssl
  ];
  
  src = ./.;

  # FIXME deciding what modules are available is quite verbose now
  # concatStringSep
  CXXFLAGS= with modules; concatStringsSep " " [
    (optionalString (bitcoin-core != null) "-DBITCOIN_CORE")
    (optionalString (rustbitcoin != null) "-DRUST_BITCOIN")
    (optionalString (rustbitcoinkernel != null) "-DRUSTBITCOINKERNEL")
    (optionalString (pybitcoinkernel != null) "-DPYBITCOINKERNEL")
    (optionalString (ldk != null) "-DLDK")
    (optionalString (lnd != null) "-DLND")
    (optionalString (btcd != null) "-DBTCD")
    (optionalString (nbitcoin != null) "-DNBITCOIN")
  ];

  # FIXME deciding what modules are available is quite verbose now
  configurePhase = with modules; concatLines [
    (optionalString (bitcoin-core != null) "cp ${bitcoin-core.outPath}/modules/bitcoin/module.a modules/bitcoin/")
    (optionalString (rustbitcoin != null) "cp ${rustbitcoin.outPath}/modules/rustbitcoin/module.a modules/rustbitcoin/")
    (optionalString (rustbitcoinkernel != null) "cp ${rustbitcoinkernel.outPath}/modules/rustbitcoinkernel/module.a modules/rustbitcoinkernel/")
    (optionalString (pybitcoinkernel != null) "cp ${pybitcoinkernel.outPath}/modules/pybitcoinkernel/pybitcoinkernel_lib.py ./main.py")
    (optionalString (pybitcoinkernel != null) "cp ${pybitcoinkernel.outPath}/modules/pybitcoinkernel/module.a modules/pybitcoinkernel")
    (optionalString (ldk != null) "cp ${ldk.outPath}/modules/ldk/module.a modules/ldk/")
    (optionalString (lnd != null) "cp ${lnd.outPath}/modules/lnd/module.a modules/lnd/")
    (optionalString (btcd != null) "cp ${btcd.outPath}/modules/btcd/module.a modules/btcd/")
    (optionalString (nbitcoin != null) "cp ${nbitcoin.outPath}/modules/nbitcoin/module.a modules/nbitcoin/")
    (optionalString (nbitcoin != null) "cp ${nbitcoin.outPath}/NBitcoin.CppBridge.so ./")
  ];

  # LD_LIBRARY_PATH = lib.makeLibraryPath [ modules.nbitcoin.outPath openssl openssl.dev ];

  installPhase = ''
    install ${pname} --preserve-timestamps -D --target-directory $out/bin/

    librarypath="${lib.makeLibraryPath runtimeLibDeps}"

    wrapProgram $out/bin/${pname} --prefix LD_LIBRARY_PATH : "$librarypath"
  '';
}
