PROJECT_NAME = File.basename(Dir.pwd)

Vagrant.configure('2') do |config|
  config.vm.provider 'virtualbox'
  config.vm.box = 'generic/arch'
  config.vm.hostname = "vg-#{PROJECT_NAME}"

  config.vm.synced_folder '.', "/home/vagrant/#{PROJECT_NAME}"

  # Copy over the SSH key.
  config.vm.provision 'file', source: '~/.ssh/id_rsa', destination: '~/.ssh/id_rsa'

  # Install project dependencies.
  config.vm.provision 'shell', inline: "echo #{PROJECT_NAME} > /etc/projectname"

  # Install the dotfiles.
  config.vm.provision 'shell', privileged: false, inline: <<~SH
    curl -O https://raw.githubusercontent.com/botanicus/dotfiles/master/.scripts/dotfiles/dotfiles.install-vagrant
    chmod +x dotfiles.install-vagrant
    ./dotfiles.install-vagrant && rm ./dotfiles.install-vagrant
  SH

  # Install the project.
  config.vm.provision 'shell', privileged: false, inline: <<~SH
    sudo pacman -S --noconfirm ruby
    gem install bundler --no-rdoc --no-ri && cd #{PROJECT_NAME} && bundle
  SH
end
