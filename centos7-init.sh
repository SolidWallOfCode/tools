# This is the minimal set of things needed to get the rest of the install scripting to work.
cd ~
mkdir .ssh
chmod 700 .ssh
cd .ssh
cp ~/git/tools/keys/*.pub.key .
cat tidus.pub.key >> authorized_keys
cat waka.pub.key >> authorized_keys
cat tifa.pub.key >> authorized_keys
cat besaid.pub.key >> authorized_keys
cat spira.pub.key >> authorized_keys
chmod 600 *
