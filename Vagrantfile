# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

cluster = {
  "box1" => { :ip => "192.168.56.31", :cpus => 1, :mem => 2048 , :ssh_port => 2200},
  # "box2" => { :ip => "192.168.56.32", :cpus => 1, :mem => 512 , :ssh_port => 2201},
  # "box3" => { :ip => "192.168.56.33", :cpus => 1, :mem => 512 , :ssh_port => 2202}
}

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  cluster.each_with_index do |(hostname, info), index|
    config.hostmanager.enabled = true
    # config.hostmanager.manage_host = true
    config.hostmanager.manage_host = false
    config.hostmanager.manage_guest = true
    # config.hostmanager.manage_guest = false
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true

    config.vm.define hostname do |cfg|
      # cfg.vm.box = "geerlingguy/debian10"
      cfg.vm.box = "debian/bullseye64"
      # cfg.vm.box = "hennersz/nixos-23.05"
      cfg.vm.provider :libvirt do |libvirt, override|
        override.vm.network :private_network, ip: "#{info[:ip]}"
        override.vm.network :forwarded_port, guest: 22, host: "#{info[:ssh_port]}", id: 'ssh'
        override.vm.hostname = hostname
        libvirt.forward_ssh_port = true
        libvirt.memory  = info[:mem]
        libvirt.cpus = info[:cpus]
      end # end provider

      config.ssh.insert_key = false
      config.vm.synced_folder ".", "/vagrant", disabled: true
    end # end config
  end # end cluster
end
