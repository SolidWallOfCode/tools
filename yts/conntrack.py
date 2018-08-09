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
    addr = {}
    fqdn = {}
    a_addr = {}
    a_fqdn = {}
    data = json.load(stream)
    data['connectionCountList'].sort(key=lambda count: count['count'])
    for group in data['connectionCountList'] :
        addr[group['ip']] = 1
        fqdn[group['fqdn']] = 1
        total += group['count']
        if group['count'] > 0 :
            active += 1
            a_addr[group['ip']] = 1
            a_fqdn[group['fqdn']] = 1
            print("count {:<4} addr {:<20} block {:2} alert {}".format(group['count'], group['ip'], group['block'], group['alert']))

    print("{} groups active with {} connections, {}/{} addresses, {}/{} fqdns".format(active, total, len(a_addr), len(addr), len(a_fqdn), len(fqdn)))
