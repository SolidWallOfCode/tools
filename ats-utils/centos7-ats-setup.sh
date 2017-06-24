sudo yum upgrade
# For local networking, edit the connection to have a DHCP client id that
# matches the hostname.
#dnf install gcc gcc-c++ autoconf automake libtool gdb bison flex openssl openssl-devel tcl-devel pcre-devel hwloc-devel patch emacs wireshark-gnome libcap-devel perl-ExtUtils-MakeMaker doxygen graphviz libxml2-devel gpg libffi-devel python-devel python-virtualenv python-lxml system-config-users nghttp2 libyaml-devel redhat-rpm-config jemalloc-devel clang llvm clang-analyzer lm_sensors xfce4-sensors-plugin
sudo yum install gcc gcc-c++ autoconf automake libtool gdb bison flex openssl-devel tcl-devel pcre-devel libxml2-devel hwloc-devel patch emacs libcap-devel perl-ExtUtils-MakeMaker doxygen graphviz libffi-devel python-devel python-virtualenv python-pip redhat-rpm-config 

sudo pip install --upgrade pip
sudo pip install sphinx

# redhat-rpm-config is for installing Python pacakges via PIP that need to be compiled.
