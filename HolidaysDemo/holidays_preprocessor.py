#!/usr/bin/env python

import sys

def gen_sql():
    for line in sys.stdin:
        parts = [a.strip() for a in line.split('\t') if len(a) > 0]
        print "INSERT INTO holidays (country, name, date_of_event) VALUES ('%s', '%s', '%s');" % tuple(parts[0:3])
        del parts[2]
        print "INSERT INTO holidays (country, name, date_of_event) VALUES ('%s', '%s', '%s');" % tuple(parts)

if __name__ == '__main__':
    gen_sql()

