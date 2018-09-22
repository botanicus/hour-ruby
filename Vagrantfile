PROJECT_NAME = File.basename(Dir.pwd)

Vagrant.configure('2') do |config|
  config.vm.provider 'virtualbox'
  config.vm.box = 'generic/arch'
  config.vm.synced_folder '.', "/home/vagrant/#{PROJECT_NAME}"
  # config.vm.provision 'shell',
  #   inline: 'pacman -Syu --noconfirm && pacman -S --noconfirm ruby'

  # We have to override ~/.bashrc, because otherwise it exits when run non-interactively.
  config.vm.provision 'shell', privileged: false,
    inline: 'echo "export PATH=~/.gem/ruby/2.5.0/bin:\$PATH" > ~/.bashrc'

  config.vm.provision 'shell', privileged: false,
    inline: "gem install bundler --no-rdoc --no-ri && cd #{PROJECT_NAME} && bundle"

  # End-user tweaks.
  config.vm.provision 'shell', privileged: false,
    inline: "echo 'cd #{PROJECT_NAME}' >> ~/.bashrc"
end
