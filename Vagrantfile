VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'precise32'
  config.vm.box_url = 'http://files.vagrantup.com/precise32.box'

  config.vm.synced_folder './', '/home/vagrant/tpm'

  config.vm.provision 'shell', path: 'vagrant_provisioning.sh'
end
