#!/bin/sh
dir=${1:-y}
if [ ! -d ${dir} ] ; then
  mkdir $dir;
fi

cd $dir
base=$(pwd)

if [ ! -d yts ] ; then
  git clone git@partner.git.corp.yahoo.com:Edge/trafficserver.git yts
  cd yts
  git remote rename origin y
  git remote add ats git@github.com:apache/trafficserver.git
  git remote add swoc git@github.com:SolidWallOfCode/trafficserver.git
  git remote add yswoc git@partner.git.corp.yahoo.com:solidwallofcode/trafficserver.git
  cd ${base}
fi

if [ ! -d ybuild ] ; then
  git clone git@partner.git.corp.yahoo.com:Edge/build.git ybuild
  cd ybuild
  git remote rename origin y
  git remote add yswoc git@partner.git.corp.yahoo.com:solidwallofcode/build.git
  cd ${base}
fi

if [ ! -d ypkg ] ; then
  git clone git@partner.git.corp.yahoo.com:Edge/package.git ypkg
  cd ypkg
  git remote rename origin y
  git remote add yswoc git@partner.git.corp.yahoo.com:solidwallofcode/package.git
  cd ${base}
fi
