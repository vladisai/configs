#!/usr/bin/env python3

from subprocess import Popen, PIPE, check_output
import sys

diskSymbol = ''

def runCommand(command):
    return check_output(command, shell = True).decode(encoding = 'utf-8')

def getFreeSpaceHome():
    command = "df -h | awk '/\/home/{print $4}'"
    ret = runCommand(command)
    if ret[-1] == '\n':
        ret = ret[:-1]
    return ret

def getFreeSpaceRoot():
    command = "df -h | awk '/\/$/{print $4}'"
    ret = runCommand(command)
    if ret[-1] == '\n':
        ret = ret[:-1]
    return ret

def buildStatusBarString():
    return diskSymbol + ' /' + getFreeSpaceRoot() + ' ~/' + getFreeSpaceHome()

if __name__ == '__main__':
    print(buildStatusBarString())

