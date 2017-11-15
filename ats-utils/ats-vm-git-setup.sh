#!/bin/sh
dir=${1:-ats}
git clone https://github.com/apache/trafficserver.git ${dir}
if [ -d ${dir} ] ; then
    cd ${dir}
    git remote rename origin ats
    git remote add swoc https://github.com/SolidWallOfCode/trafficserver.git
    git remote add asf https://gitbox.apache.org/repos/asf/trafficserver.git
    if [ -d ../tools/ats-utils ] ; then
        cp ../tools/ats-utils/config.nice .
    fi
fi
