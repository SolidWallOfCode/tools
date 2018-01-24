#!/usr/bin/env python
import os
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("path",help="Path to source")
args = parser.parse_args()

file = open(args.path,"r")
dict = {}
count = 0
max = 0
duplicates = 0
sec = 0
most_requested = ""

for line in file:
    count+=1
    line_array = line.split(" ")
    if not dict.has_key(line_array[7]):
                dict[line_array[7]] = {"count":1,"size":int(line_array[5]), "first_time":float(line_array[0]), "last_time":float(line_array[0])}
    else:
        dict[line_array[7]]["count"] += 1
        dict[line_array[7]]["last_time"]=float(line_array[0])

k_v=[]

for keys,values in dict.items ():
    k_v.append((keys,values["count"]))
    if(values["count"]>max):
        max = values["count"]
        most_requested = keys
    if(values["count"]>1):
        duplicates+=1

#print k_v
k_v = sorted(k_v, key = lambda value: -value[1])
    
print("Number of unique URLS" , len(dict), count,duplicates,most_requested,max, dict[most_requested]["size"])

for i in range(25):
    #     URL         count      size                   dt
    print(k_v[i][0], k_v[i][1], dict[k_v[i][0]]["size"], dict[k_v[i][0]]["last_time"]-dict[k_v[i][0]]["first_time"])