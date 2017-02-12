#!/usr/bin/env python3

from subprocess import Popen, PIPE, check_output
import sys

loadSymbol = ''

def runCommand(command):
    return check_output(command, shell = True).decode(encoding = 'utf-8')

def getLoad():
    command = "mpstat | awk '/all/{print $12}'"
    ret = runCommand(command)
    return 100 - int(float(ret))

def buildStatusBarString():
    ret = []
    ret.append(loadSymbol)
    ret.append(str(getLoad()) + '%')
    return ' '.join(ret)

if __name__ == "__main__":
    print(buildStatusBarString())
