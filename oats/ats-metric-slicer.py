#! /usr/bin/python3

import argparse
import time
from array import array
import sys

command_parser = argparse.ArgumentParser()
command_parser.add_argument("path", help="Path to source data file")
command_parser.add_argument("--tag", help="Column tags for output slices", dest='tags', action='append' )
command_parser.add_argument("--out", help="Output file for sliced data.")
args = command_parser.parse_args()

table = {}
columns = []
time_marks = []
tidx = 1

try :
  with open(args.path) as data :
    print("Processing input '{}'".format(args.path))
    if len(args.tags) > 0 :
      print("Outputting tags '{}'".format("','".join(args.tags)))
    for line in data :
      line = line.strip()
      if '*' == line[0] :
        labels = line[2:].split(',')
        print("Column Header with {} labels".format(len(labels)))
        columns = [] # clear active columns
        for tag in labels :
          tag = tag.strip()
          columns.append(tag)
          if tag not in table :
            table[tag] = array('l')
      else :
        (time, data) = line.split('=')
        items = data.split(',')
        if len(items) == len(columns) :
          for n in zip(columns, items) :
            table[n[0]].insert(tidx, int(n[1]))
          time_marks.append(time.strip())
          tidx += 1

except FileNotFoundError as ex:
  print("Unable to find '{}'".format(args.path))
except IOError as ex :
  print("Unable to open :", ex, " ", args.path)

bad = []
for t in args.tags :
  if t not in table :
    bad.append(t)
if len(bad) :
  print("Error: tags '{}' not found in data".format("','".join(bad)))
  sys.exit(1)

print("Total intervals {}".format(len(time_marks)))
tidx = 0
if args.out :
  with open(args.out, mode='w') as out :
    print("Time,{}".format(",".join(args.tags)), file=out)
    for tm in time_marks :
      q = ["{}".format(table[t][tidx]) for t in args.tags]
      print("{},{}".format(tm, ",".join(q)), file=out)
      tidx += 1
