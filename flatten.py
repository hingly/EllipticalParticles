#!/usr/bin/env python

#Start: Wed Oct 17 14:53:51 SAST 2012
#Finish: Wed Oct 17 15:37:55 SAST 2012

# python flatten.py guess_test/exitflag,guess_test/output Guess/ellipse/uniaxial/guess*strain_10_*ar_5* | tr "," "\t" > Guess/ellipse/uniaxial/strain_10_ar_5.tab.csv



import csv
import json
import sys

try:
    raise ImportError
    import argparse
    parser = argparse.ArgumentParser('Collect JSON files into CSV files')
    parser.add_argument('item', nargs=1,
                        help='Comma separated path of item (eg a/b,a/c)')
    parser.add_argument('files', nargs="+", type=argparse.FileType('r'),
                        help='Files to parse')
    parser.add_argument('--output', '-o',
                        type=argparse.FileType('w'),
                        default=sys.stdout,
                        help='Output file - default is stdout')
    simpleargs = False
except ImportError:
    simpleargs = True

def flattenlist(l):
    if type(l) is not list:
        yield l
    else:
        for item in l:
            for elem in flattenlist(item):
                yield elem
                

if __name__=="__main__":
    if simpleargs:
        itemstring = sys.argv[1]
        outstream = sys.stdout
    else:
        args = parser.parse_args()
        itemstring = sys.argv.item[0]
        outstream = args.output
        
    items = itemstring.split(',')
    out = csv.writer(outstream)
    for f in sys.argv[2:]:
        if simpleargs:
            f = open(f, 'r')
        contents = json.loads(f.read())
        outrow = []
        for item in items:
            current = contents
            for pathitem in item.split('/'):
                current = current[pathitem]
                if type(current) is dict and '_ArrayData_' in current:
                    current = current['_ArrayData_']
                    break
            if type(current) is list:
                outrow += list(flattenlist(current))
            else:
                outrow.append(current)
        out.writerow(outrow)
            
