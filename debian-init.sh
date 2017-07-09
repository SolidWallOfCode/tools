#
# This command must be run by hand to get started.
# wget https://raw.githubusercontent.com/SolidWallOfCode/tools/master/debian-init.sh
#
echo Use the root password during initial setup.
su --command 'apt-get install sudo'
su --command 'usermod -aG sudo amc'
su --command 'apt-get install git'

cd ~
mkdir git
cd git
git clone https://github.com/solidwallofcode/tools.git tools

cd ~
mkdir .ssh
chmod 700 .ssh
cd .ssh
cp ~/git/tools/keys/*.pub.key .
cat tidus.pub.key >> authorized_keys
cat waka.pub.key >> authorized_keys
cat tifa.pub.key >> authorized_keys
cat besaid.pub.key >> authorized_keys
cat spira.pub.key >> authorized_keys
chmod 600 *

echo Log out is now required to enable sudo.
