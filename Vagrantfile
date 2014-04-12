# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "debian-7.2.0"
  config.vm.box_url = "https://dl.dropboxusercontent.com/u/197673519/debian-7.2.0.box"

  config.vm.network :private_network, ip:"172.17.2.3"

  #config.vm.synced_folder("./data", "/vagrant", nfs: (RUBY_PLATFORM =~ /linux/ or RUBY_PLATFORM =~ /darwin/))

  config.vm.synced_folder "./data", "/vagrant",
    :nfs => true,
    :mount_options => ['actimeo=2']

  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 2
  end

  $script = <<EOF
mkdir -p /etc/puppet/modules
(puppet module list | grep puppetlabs-apt) ||
   puppet module install puppetlabs-apt --version 1.4.2
EOF

  config.vm.provision :shell, :inline => $script

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "base.pp"
    puppet.options = ['--verbose --debug']
  end

end
