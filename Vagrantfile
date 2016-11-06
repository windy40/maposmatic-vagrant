# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/xenial64"

  config.vm.network "forwarded_port", guest: 80, host: 8000

  config.vm.provider "virtualbox" do |vb|
    # vb.gui = true
    vb.name = "maposmatic"
    vb.memory = "4096"
    vb.cpus   = "2"

    # create a 2nd virtual disk as the base box file system isn't large enough
    unless File.exist?('db_disk.vdi')
      vb.customize ['createhd', '--filename', 'db_disk', '--size', 100 * 1024] # 100GB
    end
    vb.customize ['storageattach', :id, '--storagectl', 'SCSI Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', 'db_disk.vdi']
  end

  config.ssh.forward_x11=true

  config.vm.provision "shell", path: "provision.sh"
  
end
