#!/bin/bash
cd ~
if [ ! -d git ] ; then
    mkdir git
fi
cd git
git clone https://github.com/gsand/mark2

cd ~
if [ ! -d bin ] ; then
    mkdir bin
fi

if [ ! -f ~/bin/mark2 ] ; then
    ln -s ~/git/mark2/mark2 ~/bin/mark2
fi

if ! grep -q MARK2_CONFIG_DIR .bash_profile ; then
    echo 'export MARK2_CONFIG_DIR=/home/minecraft/server' >> .bash_profile
fi

if [ ! -d server ] ; then
    mkdir server
fi

if [ ! -f server/mark2.properties ] ; then
    cat <<MARK2_CONFIG > server/mark2.properties
java.cli.X.ms=1024M
java.cli.X.mx=1024M
# Use whatever mark2 saved the JAR as here
mark2.jar-path=spigot*.jar
# Saving notifications aren't really useful
plugin.save.warn-message=
plugin.save.message=
# This helps stop GC hangs
java.cli.XX.UseConcMarkSweepGC=true
MARK2_CONFIG
fi

# pip install -r git/mark2/requirements.txt
