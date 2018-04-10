#!/usr/bin/env python
import os
import argparse
import json

parser = argparse.ArgumentParser()
parser.add_argument("source",help="Input file")
args = parser.parse_args()

with open(args.source) as stream:
    active = 0 # count of groups with non-zero counts
    total = 0 # count of open sessions in groups
    data = json.load(stream)
    data['connectionCountList'].sort(key=lambda count: count['count'])
    for group in data['connectionCountList'] :
        total += group['count']
        active += group['count'] > 0
        print("count {:<4} addr {:<20} block {:2} alert {}".format(group['count'], group['ip'], group['block'], group['alert']))

    print("{} groups active with {} connections".format(active, total))
