{
  inputs,
  cell,
}: {
  box1 = {
    networking.hostName = "box1";
    deployment = {
      targetHost = "192.168.56.31";
    };
    imports = [cell.nixosConfigurations.box1];
  };
}
