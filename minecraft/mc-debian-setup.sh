sudo echo 'deb http://http.debian.net/debian jessie-backports main' >> /etc/apt/sources.list.d/jessie-backports.list
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install gcc libssl-dev python-pip python-dev libffi-dev
sudo apt-get install -t jessie-backports openjdk-8-jdk
# Not sure if this is needed.
#sudo update-java-alternatives -s java-1.8.0-openjdk-amd64

sudo useradd --shell /bin/bash --create-home minecraft
sudo mkdir ~minecraft/.ssh
sudo chmod 750 ~minecraft/.ssh
sudo chgrp minecraft ~minecraft/.ssh
sudo cp ~amc/.ssh/*.pub.key ~minecraft/.ssh
sudo cp ~amc/.ssh/authorized_keys ~minecraft/.ssh
sudo $SHELL -c 'chmod 640 ~minecraft/.ssh/*'
sudo $SHELL -c 'chgrp minecraft ~minecraft/.ssh/*'

sudo usermode --groups minecraft --append amc
