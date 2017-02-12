#!/usr/bin/env python3
from subprocess import Popen, PIPE, check_output
import sys

baseCommand = 'amixer -c 1'
mutedSymbol = ''
unmutedSymbol = ''

def runCommand(command):
    return check_output(command, shell = True).decode(encoding = 'utf-8')

def updateStatusBar():
    runCommand('pkill -RTMIN+1 i3blocks')

def getMasterStatus():
    command = baseCommand + ' get Master'
    command += " | awk '/%/{print $6}'"
    ret = runCommand(command)
    ret = str(ret[1:-2])
    return ret

def getSpeakerStatus():
    command = baseCommand + ' get Speaker'
    command += " | awk '/Right.*%/{print $7}'"
    ret = runCommand(command)
    ret = str(ret[1:-2])
    return ret

def getHeadphoneStatus():
    command = baseCommand + ' get Headphone'
    command += " | awk '/Right.*%/{print $7}'"
    ret = runCommand(command)
    ret = str(ret[1:-2])
    return ret

def getOverallStatus():
    master = getMasterStatus()
    headphone = getHeadphoneStatus()
    if master == 'on' and headphone == 'on':
        return 'on'
    else:
        return 'off'

def toggleMaster():
    runCommand(baseCommand + ' set Master toggle')

def toggleHeadphone():
    runCommand(baseCommand + ' set Headphone toggle')

def toggle():
    master = getMasterStatus()
    headphone = getHeadphoneStatus()
    overall = getOverallStatus()
    if master == overall:
        toggleMaster()
    if headphone == overall:
        toggleHeadphone()

def setStatus(status):
    master = getMasterStatus()
    headphone = getHeadphoneStatus()
    overall = getOverallStatus()
    if master != status:
        toggleMaster()
    if headphone != status:
        toggleHeadphone()

def getVolume():
    command = baseCommand + ' get Master'
    command += " | awk '/%/{print $4}'"
    ret = runCommand(command)
    ret = int(ret[1:-3])
    return ret

def adjustVolume(val):
    oldVal = getVolume()
    strval = str(val)
    if val > 0:
        strval += '+'
    else:
        strval = strval[1:] + '-'
    command = baseCommand + ' set Master ' + strval
    runCommand(command)
    newVal = getVolume()
    
    if oldVal > 0 and newVal == 0:
        setStatus('off')
    elif oldVal == 0 and newVal > 0:
        setStatus('on')

def getGeneralStatus():
    vol = getVolume()
    symbol = 'x'
    strvol = str(vol) + '%'
    status = getOverallStatus()
    if status == 'on':
        symbol = unmutedSymbol
    else:
        symbol = mutedSymbol 
    return ' '.join([symbol, strvol])

if __name__ == "__main__":
    if len(sys.argv) < 2:
        exit(0)

    cmd = sys.argv[1]
    if cmd == 'adjust':
        adjustVolume(int(sys.argv[2]))
        updateStatusBar()
    elif cmd == 'read':
        print(getGeneralStatus())
    elif cmd == 'toggle':
        toggle()
        updateStatusBar()

