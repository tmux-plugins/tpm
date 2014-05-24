Vagrant.require_version '>= 1.6.0'

VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.provider 'docker' do |d|
    d.build_dir = '.'
    d.has_ssh = true
  end

  # tpm is synced with `/root/tmux_plugin_manager` in vagrant
  config.vm.synced_folder '../', '/root/tmux_plugin_manager'

  config.ssh.username = 'root'
  config.ssh.private_key_path = 'docker_ssh.key'
end
