#!/usr/bin/python
import sys
sys.stdout.write("badchars = (b\"")

allchars = range(0,256)
badchars = set()
for arg in sys.argv[1:]:
    badchars.add(int(arg, 16))
goodchars = set(allchars).symmetric_difference(badchars)
count = 0
for x in goodchars:
        sys.stdout.write ("\\x" + '{:02x}'.format(x))
        count = count + 1
        if (count % 16 == 0):
            sys.stdout.write("\"\nb\"")

sys.stdout.write("\")")
