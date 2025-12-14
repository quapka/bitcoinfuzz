{
  buildGoModule
}:
buildGoModule rec {
  pname = "lnd";
  name = "bitcoinfuzz-${pname}";
  src = ./.;

	# cd lnd_wrapper && go build -o liblnd_wrapper.a -buildmode=c-archive -tags=libfuzzer -gcflags=all=-d=libfuzzer wrapper.go
  vendorHash = "sha256-g0F8GdZeJI7nFkbj0cwX+rG8gKyguo3By1DqemGMEe4=";

  # ldflags = [
  #   "-o liblnd_wrapper.a"
  #   "-buildmode=c-archive"
  #   # "-gcflags=all=-d=libfuzzer"
  # ];

  # tags = [
  #   "libfuzzer"
  # ];

  buildPhase = ''
	go build -o liblnd_wrapper.a -buildmode=c-archive -tags=libfuzzer -gcflags=all=-d=libfuzzer wrapper.go
  '';

  installPhase = ''
    install --preserve-timestamps -D --target-directory $out/ liblnd_wrapper.a
  '';
  # GOBIN="${placeholder "out"}/";
}
