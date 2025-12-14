{
  buildGoModule
}:
buildGoModule rec {
  pname = "btcd_wrapper";
  name = "bitcoinfuzz-${pname}";

  vendorHash = "sha256-q4n4aLRCllP8oI+HdMAiOw1h0YRvruGy6AfrUJnVhs8";

  src = ./.;

  buildPhase = ''
    export CGO_ENABLED=0
    go build -o libbtcd_wrapper.a -buildmode=c-archive -tags=libfuzzer -gcflags=all=-d=libfuzzer wrapper.go
  '';

  installPhase = ''
    install --preserve-timestamps -D --target-directory $out/ libbtcd_wrapper.a
  '';
}

