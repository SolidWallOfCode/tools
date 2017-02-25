#hostnamectl set-hostname --static "NAME"
dnf upgrade
# For local networking, edit the connection to have a DHCP client id that
# matches the hostname.
dnf install gcc gcc-c++ autoconf automake libtool gdb bison flex openssl openssl-devel tcl-devel pcre-devel patch emacs wireshark-gnome libcap-devel git perl-ExtUtils-MakeMaker python-sphinx doxygen graphviz libxml2-devel gpg libffi-devel python-devel python-virtualenv python-lxml system-config-users nghttp2 libyaml-devel redhat-rpm-config jemalloc-devel

pip install --upgrade pip
pip install sphinx

# redhat-rpm-config is for installing Python pacakges via PIP that need to be compiled.
 
systemctl enable sshd.service
systemctl start sshd.service
