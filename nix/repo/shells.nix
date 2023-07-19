{
  inputs,
  cell,
}: let
  inherit (inputs.std) lib;
in {
  # Tool Homepage: https://numtide.github.io/devshell/
  default = lib.dev.mkShell {
    name = "Check24 DevOps Task";

    commands = [
      {
        category = "virtualisation";
        package = inputs.nixpkgs.vagrant;
      }
      {
        category = "configuration management";
        package = inputs.nixpkgs.puppet-bolt;
      }
      {
        category = "general commands";
        package = inputs.nixpkgs.hostctl;
      }
      {
        category = "nixos commands";
        package = inputs.colmena.packages.colmena;
      }
      {
        category = "nixos commands";
        package = inputs.nixos-anywhere.packages.default;
      }
    ];
  };
}
