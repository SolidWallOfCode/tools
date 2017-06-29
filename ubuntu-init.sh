sudo apt-get install git

if [ ! -d git ] ; then
	mkdir git
fi
cd git
if [ ! -d tools ] ; then
	git clone https://github.com/solidwallofcode/tools.git tools
fi

cd ~
mkdir .ssh
chmod 700 .ssh
cd .ssh
cp ~/git/tools/keys/besaid.pub.key .
cp ~/git/tools/keys/waka.pub.key .
cp ~/git/tools/keys/tidsu.pub.key .
cp ~/git/tools/keys/tifa.pub.key .
cat *.pub.key > authorized_keys
chmod 600 *
cd ..
