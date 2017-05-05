# This is the minimal set of things needed to get the rest of the install scripting to work.
mkdir .ssh
chmod 700 .ssh
cd .ssh
curl --remote-name http://network-geographics.com/amc/besaid.pub.key
curl --remote-name http://network-geographics.com/amc/tidus.pub.key
curl --remote-name http://network-geographics.com/amc/waka.pub.key
cat *.pub.key >> authorized_keys
chmod 600 *
cd ..
sudo dnf install git
mkdir git
cd git
git clone https://github.com/solidwallofcode/tools.git tools
