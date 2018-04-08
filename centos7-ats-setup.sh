sudo yum upgrade
# For local networking, edit the connection to have a DHCP client id that
# matches the hostname.
sudo yum install gcc gcc-c++ autoconf automake libtool gdb bison flex openssl openssl-devel tcl-devel pcre-devel hwloc-devel patch libcap-devel perl-ExtUtils-MakeMaker doxygen graphviz libxml2-devel libffi-devel python-devel python-virtualenv python-lxml libyaml-devel redhat-rpm-config clang llvm clang-analyzer python-pip java

sudo pip install --upgrade pip
sudo pip install sphinx sphinx-rt-theme sphinxcontrib-plantuml

# redhat-rpm-config is for installing Python pacakges via PIP that need to be compiled.
