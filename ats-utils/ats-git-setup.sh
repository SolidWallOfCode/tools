#!/bin/sh
dir=${1:-ats}
git clone https://github.com/apache/trafficserver.git ${dir}
cd ${dir}
git remote add swoc git@github.com:SolidWallOfCode/trafficserver.git
git remote add asf https://git-dual.apache.org/repos/asf/trafficserver.git
