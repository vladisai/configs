#!/usr/bin/env python3

from subprocess import Popen, PIPE, check_output
import sys
from datetime import datetime
import os

file_path = os.path.expanduser('~/Documents/anti_procrastination_log')

def runCommand(command):
    return check_output(command, shell = True).decode(encoding = 'utf-8')

if __name__ == "__main__":
    if len(sys.argv) < 2:
        exit(0)

    if sys.argv[1] == 'start':
        excuse = input('your excuse?\n')
        out = '{0} : opened because "{1}"\n'.format(str(datetime.now()), excuse)
        print(out)
        with open(file_path, 'a') as f:
            f.write(out)
    elif sys.argv[1] == 'end':
        out = '{0} : end of session\n\n'.format(str(datetime.now()))
        print(out)
        with open(file_path, 'a') as f:
            f.write(out)
