sudo dnf upgrade
# For local networking, edit the connection to have a DHCP client id that
# matches the hostname.
sudo dnf install gcc gcc-c++ autoconf automake libtool gdb bison flex openssl openssl-devel pcre-devel pcre2-devel hwloc-devel patch libcap-devel perl-ExtUtils-MakeMaker doxygen graphviz libxml2-devel libffi-devel python-virtualenv python-lxml

python3 -m pip install --user --upgrade pip
python3 -m pip install --user sphinx sphinx-rtd-theme sphinxcontrib-plantuml sphinxcontrib-doxylink

# redhat-rpm-config is for installing Python pacakges via PIP that need to be compiled.
