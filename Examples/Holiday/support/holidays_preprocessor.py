#!/usr/bin/env python

import sys

def gen_sqlite():
    print "CREATE TABLE holidays ( id INTEGER PRIMARY KEY, name VARCHAR(50), country VARCHAR(30), date_of_event VARCHAR(10) );"
    print
    for line in sys.stdin:
        parts = [a.strip() for a in line.split('\t') if len(a) > 0]
        print "INSERT INTO holidays (country, name, date_of_event) VALUES ('%s', '%s', '%s');" % tuple(parts)

def gen_json():
    print "["
    first_time = True
    for line in sys.stdin:
        parts = [a.strip() for a in line.split('\t') if len(a) > 0]
        if not first_time: print ",",
        first_time = False
        print "{ \"country\": \"%s\", \"name\": \"%s\", \"date\": \"%s\" }" % tuple(parts)
    print "]"


if __name__ == '__main__':
    def bad_args():
        print "usage: holidays_preprocessor.py [ sqlite | json ]"
        exit(1)
    
    if len(sys.argv) != 2:
        bad_args()
        
    format = sys.argv[1]
    if format == "sqlite": gen_sqlite()
    elif format == "json": gen_json()
    else: bad_args()


