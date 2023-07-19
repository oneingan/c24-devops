{
  description = "Check24 DevOps task";

  inputs.std.url = "github:divnix/std";
  inputs.std.inputs.nixpkgs.follows = "nixpkgs";
  inputs.std.inputs.devshell.url = "github:numtide/devshell";
  
  inputs.hive.url = "github:divnix/hive";
  inputs.hive.inputs.nixpkgs.follows = "nixpkgs";
  inputs.hive.inputs.colmena.follows = "colmena";

  inputs.nixpkgs-unstable.url = "github:oneingan/nixpkgs/update-bolt";
  inputs.nixpkgs.url = "github:numtide/nixpkgs-unfree/nixos-unstable";
  inputs.nixpkgs.inputs.nixpkgs.follows = "nixpkgs-unstable";

  inputs.nixos-anywhere.url = "github:numtide/nixos-anywhere";
  inputs.colmena.url = "github:zhaofengli/colmena";

  inputs.nixos-23-05.url = "github:nixos/nixpkgs/nixos-23.05";

  outputs = {std, hive, self, ...} @ inputs:
    std.growOn {
      inherit inputs;
      cellsFrom = ./nix;
      cellBlocks = with std.blockTypes;
        with hive.blockTypes; [
        # Development Environments
        (devshells "shells")
        # Infra Deployment
        (functions "nixosProfiles")
        colmenaConfigurations
        nixosConfigurations
      ];
    }
    {
      devShells = std.harvest self ["repo" "shells"];
      nixosConfigurations = hive.collect self "nixosConfigurations";
      colmenaHive = hive.collect self "colmenaConfigurations";
    };
}
