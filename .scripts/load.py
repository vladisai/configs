#!/usr/bin/env python3

from subprocess import Popen, PIPE, check_output
import sys
import os

loadSymbol = ''

def runCommand(command):
    return check_output(command, shell = True).decode(encoding = 'utf-8')

def getLoad():
    command = "uptime | awk '//{print $8 $9 $10}'"
    ret = runCommand(command)
    ret = ret.strip()
    ret = ret.replace(',', ' ')
    return ' '.join(map(str, list((os.getloadavg()))))

def buildStatusBarString():
    ret = []
    ret.append(loadSymbol)
    ret.append(getLoad())
    return ' '.join(ret)

if __name__ == "__main__":
    print(buildStatusBarString())
