#!/usr/bin/env python3

from pathlib import Path

batChargingSymbol = ''
bat100Symbol = ''
bat75Symbol = ''
bat50Symbol = ''
bat20Symbol = ''
bat0Symbol = ''

BAT = Path('/sys/class/power_supply/BAT1')

def read(name):
    return (BAT / name).read_text().strip()

def readInt(name):
    return int(read(name))

def buildTimeString(hours, mins):
    ret = ''
    if hours != 0:
        ret += str(hours) + 'h '
    if mins != 0:
        ret += str(mins) + 'm '
    if len(ret) > 0 and ret[-1] == ' ':
        ret = ret[:-1]
    if len(ret) == 0:
        return ''
    return ' (' + ret + ')'

def getSymbol(charge):
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

def timeString(remainingCharge, currentNow):
    if currentNow <= 0:
        return ''
    hours = remainingCharge / currentNow
    wholeHours = int(hours)
    mins = int(round((hours - wholeHours) * 60))
    if mins == 60:
        wholeHours += 1
        mins = 0
    return buildTimeString(wholeHours, mins)

def buildString():
    status = read('status')
    charge = readInt('capacity')

    if status == 'Full':
        return ' '.join([batChargingSymbol, str(charge) + '%'])

    currentNow = readInt('current_now') if (BAT / 'current_now').exists() else 0

    if status == 'Charging':
        chargeFull = readInt('charge_full')
        chargeNow = readInt('charge_now')
        remaining = max(chargeFull - chargeNow, 0)
        l = [batChargingSymbol, str(charge) + '%', timeString(remaining, currentNow)]
        return ' '.join(l)

    if status == 'Discharging':
        chargeNow = readInt('charge_now')
        l = [getSymbol(charge), str(charge) + '%', timeString(chargeNow, currentNow)]
        return ' '.join(l)

    # Unknown / Not charging
    return ' '.join([getSymbol(charge), str(charge) + '%'])

print(buildString())
