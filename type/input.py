#!/usr/bin/env python
import time
import itertools

__author__ = 'ty'


INPUT = "The quick brown fox jumps over the lazy dog"

print "Please enter '"+INPUT+"': \n"

var = ""


def compare(string1, string2, no_match_c=' ', match_c='|'):

    result_c = ''
    diff_count = 0

    if len(string2) < len(string1):
        string1, string2 = string2, string1

    for c1, c2 in itertools.izip(string1, string2):
        if c1 == c2:
            result_c += match_c
        else:
            result_c += no_match_c
            diff_count += 1
    delta = len(string2) - len(string1)
    result_c += delta * no_match_c
    diff_count += delta
    return result_c, diff_count

while var != "exit":
    try:
        before = time.time()
        var = raw_input()
        after = time.time()
        time_user_input = after-before
        if var == "exit":
            print "bye"
        else:
            result, n_diff = compare(INPUT, var, no_match_c='*')
            print result
            print INPUT
            print "used", time_user_input, "seconds,", "%d difference(s)." % n_diff, "\n"
    except EOFError:
        print "bye"
        var = "exit"
