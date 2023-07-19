{
  inputs,
  cell,
}@block: {
  base = import ./base.nix block;
  webserver = import ./webserver block;
}
