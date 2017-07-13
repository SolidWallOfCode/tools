#! /usr/bin/python
import sys
import subprocess
import time

# Really dirty hack for python 2.6 - add check_output if it's not there.
# This is in the 2.7 subprocess library, use that if possible.
if "check_output" not in dir( subprocess ):
    def f(*popenargs, **kwargs):
        if 'stdout' in kwargs:
            raise ValueError('stdout argument not allowed, it will be overridden.')
        process = subprocess.Popen(stdout=subprocess.PIPE, *popenargs, **kwargs)
        output, unused_err = process.communicate()
        retcode = process.poll()
        if retcode:
            cmd = kwargs.get("args")
            if cmd is None:
                cmd = popenargs[0]
            raise subprocess.CalledProcessError(retcode, cmd)
        return output
    subprocess.check_output = f

PREFIX='proxy.process.eventloop'
# This is the sorted set of keys/tags/column names
COLUMNS = []

while True:
    try :
        src = subprocess.check_output(["/home/y/bin/traffic_ctl", "metric", "match", PREFIX])
    except subprocess.CalledProcessError as x :
        time.sleep(60)
        continue

    lines = src.splitlines()
    current = {}
    for l in lines:
        (key, value) = l.split()
        key = key[len(PREFIX)+1:]
        if len(key) > 0 :
            current[key] = value

    if (len(current) > 0) :
        keys = current.keys()
        keys.sort()
        if (keys != COLUMNS) :
            COLUMNS = keys
            print "*", ','.join(COLUMNS)
        print time.strftime('%Y-%m-%d-%H:%M:%S'), '=', ",".join((current[key] for key in keys))
    time.sleep(10)
