# This is the minimal set of things needed to get the rest of the install scripting to work.
# Unfortunately due to KVM's lack of cut and paste, you need to type this by hand first -
#
# curl --remote-name https://raw.githubusercontent.com/SolidWallOfCode/tools/master/centos7-init.sh
#
# That should retrieve this file. After runing this, CentOS 7 should be sufficiently bootstrapped
# to get everything else via ~/git/tools and be able to remote log in.
#

cd ~

if [ ! -d git ] ; then
  mkdir git
fi

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

# Used to be seperate, but why not everytime? Less hassle.
sudo yum install epel-release
