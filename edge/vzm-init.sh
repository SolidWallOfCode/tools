##
# Configure a VZM OpenHouse VM to build Traffic Server.

set -e

sudo yum upgrade -y
sudo yum install -y autoconf automake libtool gdb bison flex openssl openssl-devel tcl-devel expat-devel pcre-devel patch wireshark-gnome libcap-devel perl-ExtUtils-MakeMaker libunwind
# Install EPEL
sudo yum install -y --enablerepo=y-extras y-rhscl-repo y-epel-release

sudo yum install -y devtoolset-8-gcc-c++
if ! grep -q devtoolset .bashrc ; then
  echo 'source /opt/rh/devtoolset-8/enable' >> .bashrc
fi
source /opt/rh/devtoolset-8/enable

sudo yum install -y rh-python36
if ! grep -q rh-python36 .bashrc ; then
  echo 'source /opt/rh/rh-python36/enable' >> .bashrc
fi
source /opt/rh/rh-python36/enable

sudo python3 -m pip install --upgrade pip
python3 -m pip install --user sphinx sphinx-rtd-theme sphinxcontrib-plantuml

if [ ! -d git ] ; then
  mkdir git
fi

cd git
if [ ! -d edge ] ; then
  mkdir edge
fi
cd edge
if [ ! -d ts ] ; then
  git clone git@git.ouroath.com:Edge/trafficserver.git ts
  if [ -d ts ] ; then
    cd ts
    git remote rename origin edge
    git remote add edge-swoc git@git.ouroath.com:SolidWallOfCode/trafficserver.git
    git remote add ats https://github.com/apache/trafficserver/trafficserver.git
  fi
fi

cd
