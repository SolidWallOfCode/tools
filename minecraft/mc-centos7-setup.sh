sudo yum install epel-release
sudo yum install java-1.8.0-openjdk-devel
sudo yum install python-devel python-pip gcc openssl-devel
sudo firewall-cmd --permanent --new-service=minecraft --set-description="Minecraft Server"
sudo firewall-cmd --permanent --service=minecraft --add-port=25565/tcp
sudo firewall-cmd --permanent --zone=public --add-service=minecraft
sudo firewall-cmd --reload

useradd --shell /bin/bash minecraft
sudo mkdir ~minecraft/.ssh
sudo chmod 750 ~minecraft/.ssh
sudo chgrp minecraft ~minecraft/.ssh
sudo cp ~amc/.ssh/*.pub.key ~minecraft/.ssh
sudo cp ~amc/.ssh/authorized_keys ~minecraft/.ssh
sudo chmod 640 ~minecraft/.ssh/*
sudo chgrp minecraft ~minecraft/.ssh/*

sudo usermod amc --groups wheel,minecraft
