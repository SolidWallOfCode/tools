#!/bin/bash
# For Fedora 25/26 Server.
# Manually install git then clone
# https://github.com/solidwallofcode/tools.git to git/tools
# This is the base script to be run before other setup scripts. This is the minimum
# amount of common stuff needed to get my basics working. After this it depends on
# what how the host is to be used.

cd ~
# This is only useful if the entire script is cut and pasted instead of fetched via git.
if [ ! -d git/tools ] ; then
  sudo dnf install git
  cd git
  git clone https://github.com/solidwallofcode/tools.git
  cd ~
fi

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
