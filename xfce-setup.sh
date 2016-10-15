#hostnamectl set-hostname --static "NAME"
dnf upgrade
# For local networking, edit the connection to have a DHCP client id that
# matches the hostname.
dnf install gcc gcc-c++ autoconf automake libtool gdb bison flex openssl openssl-devel tcl-devel pcre-devel patch emacs wireshark-gnome libcap-devel git perl-ExtUtils-MakeMaker python-sphinx doxygen graphviz libxml2-devel gpg libffi-devel python-virtualenv python-lxml system-config-users nghttp2 libyaml-devel
 
systemctl enable sshd.service
systemctl start sshd.service
