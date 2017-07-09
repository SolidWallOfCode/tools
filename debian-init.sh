echo Use the root password during initial setup.
su --command 'apt-get install sudo'
su --command 'usermod -aG sudo amc'
su --command ' apt-get install git'

mkdir .ssh
chmod 700 .ssh
cd .ssh
wget http://network-geographics.com/amc/besaid.pub.key
wget http://network-geographics.com/amc/tidus.pub.key
wget http://network-geographics.com/amc/waka.pub.key
cat *.pub.key >> authorized_keys
chmod 600 *
cd ..
mkdir git
cd git
git clone https://github.com/solidwallofcode/tools.git tools

echo Log out is now required to enable sudo.
