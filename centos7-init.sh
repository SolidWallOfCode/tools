# This is the minimal set of things needed to get the rest of the install scripting to work.
sudo yum install git

cd ~

if [ ! -d git/tools ] ; then
  sudo yum install git
  cd git
  git clone https://github.com/solidwallofcode/tools.git
  cd ~
fi

if [ ! -d .ssh ] ; then
	mkdir .ssh
	chmod 700 .ssh
fi
cd .ssh
cp ~/git/tools/keys/*.pub.key .
cat tidus.pub.key >> authorized_keys
cat waka.pub.key >> authorized_keys
cat tifa.pub.key >> authorized_keys
cat besaid.pub.key >> authorized_keys
cat spira.pub.key >> authorized_keys
chmod 600 *
