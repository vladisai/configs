#!/usr/bin/env python3

from subprocess import Popen, PIPE, check_output
import sys

#temperatureSymbol = 't '
temperatureSymbol = 't:'

def runCommand(command):
    return check_output(command, shell = True).decode(encoding = 'utf-8')

def getTemp():
    ret = runCommand("sensors | awk '/Package id 0/{print $4}'")
    ret = ret[1:-5]
    return int(ret)

print(temperatureSymbol + str(getTemp()) + "°C")


