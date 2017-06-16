git config --global --unset core.autocrlf
sudo yum install epel-release
sudo yum install java-1.8.0-openjdk-devel
sudo yum install python-devel python-pip gcc openssl-devel
sudo firewall-cmd --permanent --new-service=minecraft --set-description="Minecraft Server"
sudo firewall-cmd --permanent --service=minecraft --add-port=25565/tcp
sudo firewall-cmd --permanent --zone=public --add-service=minecraft
sudo firewall-cmd --reload
