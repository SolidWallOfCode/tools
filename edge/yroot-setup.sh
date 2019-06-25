# For local networking, edit the connection to have a DHCP client id that
# matches the hostname.
# Need to add the EPEL repo
scp localhost:epel-release-latest-6.noarch.rpm .
rpm -Uvh epel-release-latest-6.noarch.rpm
# Add these back as needed, because they should be available from the base OS and in some cases it breaks stuff (e.g. git) to update.
#yum install gcc gcc-c++ autoconf automake libtool gdb bison flex openssl openssl-devel subversion tcl-devel expat-devel pcre-devel patch emacs wireshark-gnome libcap-devel git perl-ExtUtils-MakeMaker python-sphinx libunwind
yinst install perl
