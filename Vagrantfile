require 'ostruct'
require 'erb'

Vagrant.configure(2) do |config|
  config.vm.box = 'phusion/ubuntu-14.04-amd64'

  config.vm.synced_folder '.', '/vagrant', disabled: true
  config.vm.synced_folder '.', '/home/vagrant/app'

  install_dependencies(config)
end

def install_dependencies(config)
  config.vm.provision :shell, inline: <<-SCRIPT
    apt-get -qq update
    apt-get -qq install #{dependencies.apt}
    pip install --quiet #{dependencies.pip}
  SCRIPT

  config.vm.provision :shell, privileged: false, inline: template(<<-SCRIPT, dependencies)
    [[ ! -d ~/tmp ]] && mkdir ~/tmp

    <% manual.each do |dependency| %>
      if [[ -z $(which <%= dependency.name %>) ]]; then
        curl --silent --location --output ~/tmp/<%= dependency.name %>.zip <%= dependency.url %>
        sudo unzip -qq ~/tmp/<%= dependency.name %>.zip -d /usr/local/bin
      fi
    <% end %>
  SCRIPT
end

def dependencies
  OpenStruct.new({
    apt: %q[unzip python-pip],
    pip: %q[awscli],
    manual: [
      OpenStruct.new({
        name: 'terraform',
        url: 'https://dl.bintray.com/mitchellh/terraform/terraform_0.4.2_linux_amd64.zip'
      })
    ]
  })
end

def template(s, context)
  ERB.new(s).result(context.instance_eval { binding })
end
