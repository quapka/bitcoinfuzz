{
  buildDotnetModule
}:
buildDotnetModule rec {
  pname = "nbitcoin";
  name = "bitcoinfuzz-${pname}";
}
