{
  inputs,
  cell,
}: {
  box1 = {...}: {
    bee.system = "x86_64-linux";
    bee.pkgs = import inputs.nixos-23-05 {
      inherit (inputs.nixpkgs) system;
      config.allowUnfree = true;
      overlays = [];
    };

    networking.hostName = "box1";

    networking.interfaces.ens6.ipv4.addresses = [ {
      address = "192.168.56.31";
      prefixLength = 24;
    } ];

    imports = [
      cell.nixosProfiles.base
      cell.nixosProfiles.webserver.php
    ];
  };
}
