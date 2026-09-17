#!/usr/bin/env python3

from subprocess import Popen, PIPE, check_output
import sys
import re

batChargingSymbol = ''
bat100Symbol = ''
bat75Symbol = ''
bat50Symbol = ''
bat20Symbol = ''
bat0Symbol = ''

fullRegex = '^Battery [0-9]: Full, ([0-9]*)%$'
dischargingRegex = '^Battery [0-9]: Discharging, ([0-9]*)%, ([0-9]{2})\:([0-9]{2})\:([0-9]{2}) remaining$'
chargingRegex = '^Battery [0-9]: Charging, ([0-9]*)%, ([0-9]{2}):([0-9]{2}):([0-9]{2}) until charged$'
unknownRegex = '^Battery [0-9]: Unknown, ([0-9]*)%$'

def runCommand(command):
    return check_output(command, shell = True).decode(encoding = 'utf-8')

def buildTimeString(hours, mins):
    ret = ''
    hours = int(hours)
    mins = int(mins)
    if hours != 0:
        ret += str(hours) + 'h '
    if mins != 0:
        ret += str(mins) + 'm '
    if len(ret) > 0 and ret[-1] == ' ':
        ret = ret[:-1]
    return ' (' + ret + ')'

def getSymbol(charge):
    charge = int(charge)
    if charge == 100:
        return bat100Symbol
    elif charge >= 75:
        return bat75Symbol
    elif charge >= 50:
        return bat50Symbol
    elif charge >= 20:
        return bat20Symbol
    else:
        return bat0Symbol

def buildStringForFull(charge):
    l = []
    l.append(batChargingSymbol)
    l.append(charge + '%')
    return ' '.join(l)

def buildStringForCharging(charge, hours, mins):
    l = []
    l.append(batChargingSymbol)
    l.append(charge + '%')
    l.append(buildTimeString(hours, mins))
    return ' '.join(l)

def buildStringForDischarging(charge, hours, mins):
    l = []
    l.append(getSymbol(charge))
    l.append(charge + '%')
    l.append(buildTimeString(hours, mins))
    return ' '.join(l)

def buildStringForUnknown(charge):
    l = []
    l.append(getSymbol(charge))
    l.append(charge + '%')
    return ' '.join(l)

def buildString():
    s = runCommand("acpi -b").splitlines()[0]
    matchFull = re.match(fullRegex, s)
    matchDischarging = re.match(dischargingRegex, s)
    matchCharging = re.match(chargingRegex, s)
    matchUnknown = re.match(unknownRegex, s)

    if matchFull is not None:
        charge = matchFull.group(1)
        return buildStringForFull(charge)

    elif matchDischarging is not None:
        charge = matchDischarging.group(1)
        hours = matchDischarging.group(2)
        mins = matchDischarging.group(3)
        return buildStringForDischarging(charge, hours, mins)

    elif matchCharging is not None:
        charge = matchCharging.group(1)
        hours = matchCharging.group(2)
        mins = matchCharging.group(3)
        return buildStringForCharging(charge, hours, mins)

    elif matchUnknown is not None:
        charge = matchUnknown.group(1)
        return buildStringForUnknown(charge)

print(buildString())
