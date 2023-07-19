{
  inputs,
  cell,
}: {
  pkgs,
  config,
  modulesPath,
  ...
}: {
  
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    inputs.nixos-anywhere.inputs.disko.nixosModules.disko
  ];
  
  disko.devices = import ./diskoConfiguration.nix;
  
  boot.loader.grub = {
    devices = [ "/dev/vda" ];
  };

  system.stateVersion = "23.05";
  
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFVuLMi6+cF9iDvs7wZaeIWxd20nnBeqxQVoz0r/3y+E juanjop@x2100" ];
}
