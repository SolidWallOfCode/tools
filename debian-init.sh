echo Use the root password to get sudo installed
su --command 'apt-get install sudo'
echo Now use your password for elevated access.

mkdir .ssh
chmod 700 .ssh
cd .ssh
wget http://network-geographics.com/amc/besaid.pub.key
wget http://network-geographics.com/amc/tidus.pub.key
wget http://network-geographics.com/amc/waka.pub.key
cat *.pub.key >> authorized_keys
chmod 600 *
cd ..
sudo apt-get install git
mkdir git
cd git
git clone https://github.com/solidwallofcode/tools.git tools
