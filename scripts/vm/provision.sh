#!/usr/bin/env bash

mkdir ~/.ssh
curl --location https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub > ~/.ssh/authorized_keys
chmod 0700 ~/.ssh
chmod 0600 ~/.ssh/authorized_keys
chown -R "$APP_USER" ~/.ssh

echo "$APP_PASSWORD" | sudo -S sed -i -E "/^.*?$APP_USER.*?$/d" /etc/sudoers
echo "$APP_PASSWORD" | sudo -S bash -c "echo '$APP_USER ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers"

echo "$APP_PASSWORD" | sudo sed -i -E '/^.*?UseDNS.*?$/d' /etc/ssh/sshd_config
echo "$APP_PASSWORD" | sudo -S bash -c "echo 'UseDNS no' >> /etc/ssh/sshd_config"
