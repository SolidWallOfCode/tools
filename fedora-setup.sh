sudo dnf upgrade
# For local networking, edit the connection to have a DHCP client id that
# matches the hostname.
sudo dnf install gcc gcc-c++ autoconf automake libtool gdb bison flex openssl openssl-devel tcl-devel pcre-devel hwloc-devel patch emacs libcap-devel perl-ExtUtils-MakeMaker doxygen graphviz libxml2-devel libffi-devel python-devel python-virtualenv python-lxml libyaml-devel jemalloc-devel clang llvm clang-analyzer 

sudo pip install --upgrade pip
sudo pip install sphinx sphinx-rtd-theme sphinxcontrib-plantuml

# redhat-rpm-config is for installing Python pacakges via PIP that need to be compiled.
