# -*- mode: ruby -*-
# vi: set ft=ruby :
# ensure SSH password login

# TODO Remove:
#$script = <<-SCRIPT
#sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
#systemctl restart sshd
#useradd ansible
#SCRIPT

#TODO why no rocky 9?

Vagrant.configure("2") do |config|
  # rockylinux/8 is broken does not boot
    config.vm.box = "bento/rockylinux-8"

    config.vm.define "control" do |control|
      control.vm.hostname = "control"
      control.vm.network "private_network", ip: "192.168.122.30"
    end
    config.vm.define "node1" do |node1|
      node1.vm.hostname = "node1"
      node1.vm.network "private_network", ip: "192.168.122.31"
    end
    config.vm.define "node2" do |node2|
      node2.vm.hostname = "node2"
      node2.vm.network "private_network", ip: "192.168.122.32"
    end

    config.vm.provision :ansible do |ansible|
      ansible.compatibility_mode = "2.0"
      ansible.become = true
      ansible.playbook = "setup/base.yml"
    end

  config.vm.define "gitserver" do |git_server|
      git_server.vm.hostname = "git-server"
      git_server.vm.network "private_network", ip: "192.168.122.33"
      git_server.vm.provision :ansible do |ansible|
        ansible.compatibility_mode = "2.0"
        ansible.become = true
        ansible.playbook = "setup/gitea.yml"
      end
  end
end
