# For local networking, edit the connection to have a DHCP client id that
# matches the hostname.
# Need to add the EPEL repo
sudo yum upgrade
sudo yum install autoconf automake libtool gdb bison flex openssl openssl-devel subversion tcl-devel expat-devel pcre-devel patch emacs wireshark-gnome libcap-devel git perl-ExtUtils-MakeMaker python-sphinx libunwind python-pip
# Install EPEL
sudo yum install y-epel-release --enablerepo=y-extras y-rhscl-repo epel
#wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
#sudo rpm -Uvh epel-release-latest-6.noarch.rpm
#sudo yum install devtoolset-3-gcc-c++
sudo yum install devtoolset-4-gcc-c++
sudo yinst install yopenssl
sudo yinst install yopenssl_dev
sudo yinst install git

echo This generates some warnings which seem to be safely ignored.
echo    - SNIMissingWarning, InsecurePlatformWarning:
sudo yum install python-pip
sudo pip install --upgrade pip
sudo pip install --upgrade sphinx


git clone git@partner.git.corp.yahoo.com:Edge/yats_build.git ~/git/ybuild
cd ~/git/ybuild
git remote add yswoc git@partner.git.corp.yahoo.com:solidwallofcode/yats_build.git
