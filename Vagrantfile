# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/bionic64"

  config.vm.network "forwarded_port", guest: 80, host: 8000

  config.vm.synced_folder "test", "/vagrant/test", mount_options: ["dmode=777"]

  config.vm.provider "virtualbox" do |vb|
    # vb.gui = true
    vb.name = "maposmatic"
    vb.memory = "4096"
    vb.cpus   = "2"
  end

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  unless Vagrant.has_plugin?("vagrant-disksize")
    raise 'disksize plugin is not installed - run "vagrant plugin install vagrant-disksize" first'
  end
  config.disksize.size = '150GB'

  config.ssh.forward_x11=true

  config.vm.provision "shell", path: "provision.sh"
  
end
