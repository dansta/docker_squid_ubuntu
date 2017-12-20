#!/usr/bin/env python3
""" python script to replace config parameters """

import os
import sys
import re


# read call parameters
FD = sys.argv[1]
KEYWORD = sys.argv[2]
ENV = {}

# open the config for reading
try:
    with open(FD, 'r') as CONFIGFILE:
        CONFIGDATA = CONFIGFILE.read()
        #CONFIGDATA = re.sub(r'(?m)^ *#.*\n?', '', CONFIGFILE)
except IOError:
    exit(1)

# read the environment variables that match
for i in sorted(os.environ):
    if KEYWORD in i:
        y = os.environ[i]
        ENV[i] = y

# find and replace in the config file
for i in ENV:
    if i in CONFIGDATA:
        CONFIGDATA.replace(i, ENV[i])

print(CONFIGDATA)
CONFIGFILE.close()
