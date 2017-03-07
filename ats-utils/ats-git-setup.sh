#!/bin/sh
dir=${1:-ats}
git clone git@github.com:apache/trafficserver.git ${dir}
if [ -d ${dir} ] ; then
    cd ${dir}
    git remote rename origin ats
    git remote add swoc git@github.com:SolidWallOfCode/trafficserver.git
    git remote add asf https://gitbox.apache.org/repos/asf/trafficserver.git
fi
