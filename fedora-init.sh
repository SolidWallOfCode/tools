# For Fedora 25 Server.
# This is the minimal set of things needed to get the rest of the install scripting to work.
cd ~
if [ ! -d .ssh ] ; then
  mkdir .ssh
  chmod 700 .ssh
fi
cd .ssh
cp ~/git/tools/keys/besaid.pub.key .
cp ~/git/tools/keys/waka.pub.key .
cp ~/git/tools/keys/tidus.pub.key .
cp ~/git/tools/keys/tifa.pub.key .
cat *.pub.key > authorized_keys
chmod 600 *
