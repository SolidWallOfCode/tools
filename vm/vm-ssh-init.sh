cd ~
if [ ! -d .ssh ] ; then
	mkdir .ssh
	chmod 700 .ssh
fi
cd .ssh
cp ~/git/tools/keys/*.pub.key .
chmod 400 *
cat tidus.pub.key >> authorized_keys
cat tifa.pub.key >> authorized_keys
cat besaid.pub.key >> authorized_keys
chmod 600 authorized_keys

sudo systemctl enable sshd
sudo systemctl start sshd
