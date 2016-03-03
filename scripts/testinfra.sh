#!/bin/bash

sudo salt-call --local pkg.install python-pip
sudo pip install testinfra
sudo rm -rf /vagrant/tests/__pycache__
testinfra /vagrant/tests
