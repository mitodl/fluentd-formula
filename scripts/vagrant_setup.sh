#!/bin/bash

if [ $(which apt-get) ];
then
    sudo apt-get update
    PKG_MANAGER="apt-get"
    PKGS="ca-certificates"
else
    PKG_MANAGER="yum"
    PKGS="ca-certificates"
fi

sudo $PKG_MANAGER -y install $PKGS

if [ "$(ls /vagrant)" ]
then
    SRCDIR=/vagrant
else
    SRCDIR=/home/vagrant/sync
fi
echo "Source directory is $SRCDIR"
sudo mkdir -p /srv/salt
sudo mkdir -p /srv/pillar
sudo mkdir -p /srv/formulas
sudo cp $SRCDIR/pillar.example /srv/pillar/pillar.sls
sudo cp -r $SRCDIR/fluentd /srv/salt
echo "\
base:
  '*':
    - pillar" | sudo tee /srv/pillar/top.sls
echo "\
base:
  '*':
    - fluentd
    - fluentd.plugins
    - fluentd.config
    - fluentd.reverse_proxy" | sudo tee /srv/salt/top.sls
