##
# Configure a VZM OpenHouse VM to build Traffic Server.

sudo yum upgrade -y
sudo yum install -y autoconf automake libtool gdb bison flex openssl openssl-devel tcl-devel expat-devel pcre-devel patch wireshark-gnome libcap-devel perl-ExtUtils-MakeMaker libunwind
# Install EPEL
#sudo yum install -y y-epel-release --enablerepo=y-extras y-rhscl-repo

sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y https://rhel7.iuscommunity.org/ius-release.rpm

sudo yum install -y devtoolset-8-gcc-c++
sudo yum install -y rh-python36
sudo yum remove -y git
sudo yum install -y git2u-all

python3 -m pip install --user --upgrade pip
python3 -m pip install --user sphinx sphinx-rtd-theme sphinxcontrib-plantuml

if [ ! -d git ] ; then
  mkdir git
fi

cd git
if [ ! -d oats ] ; then
  git clone git@partner.git.corp.yahoo.com:Edge/trafficserver.git oats
  if [ -d oats ] ; then
    cd oats
    git remote rename origin edge
    git remote add edge-swoc git@partner.git.corp.yahoo.com:SolidWallOfCode/trafficserver.git
    git remote add ats https://github.com/apache/trafficserver/trafficserver.git
  fi
fi

cd

if ! grep -q devtoolset .bashrc ; then
  echo 'source /opt/rh/devtoolset-8/enable' >> .bashrc
fi

if ! grep -q rh-python36 .bashrc ; then
  echo 'source /opt/rh/rh-python36/enable' >> .bashrc
fi
