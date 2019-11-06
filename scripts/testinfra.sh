#!/bin/bash

if [[ -z $(which pip) ]]
then
    sudo salt-call --local pkg.install python-pip
fi
if [[ -z $(which testinfra) ]]
then
    sudo pip install testinfra~=3.2 pytest~=4.6
fi
if [ "$(ls /vagrant)" ]
then
    SRCDIR=/vagrant
else
    SRCDIR=/home/vagrant/sync
fi
sudo rm -rf $SRCDIR/tests/__pycache__
sudo py.test $SRCDIR/tests -s
