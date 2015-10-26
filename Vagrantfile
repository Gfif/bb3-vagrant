# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "hashicorp/precise64"
  config.vm.network "forwarded_port", guest: 8000, host: 8000

  config.vm.provider "virtualbox" do |vb|
    # Customize the amount of memory on the VM:
    vb.name = "bb3"
    vb.memory = "1024"
  end

  config.vm.provision "shell", path: "setup.sh"
  
end
