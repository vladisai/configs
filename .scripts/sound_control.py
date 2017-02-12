#!/usr/bin/env python3
from subprocess import Popen, PIPE, check_output
import sys

mutedSymbol = ''
unmutedSymbol = ''

def runCommand(command):
    return check_output(command, shell = True).decode(encoding = 'utf-8')

def updateStatusBar():
    ret = runCommand('pkill -RTMIN+1 i3blocks')
    print(buildStatusString())

def getStatus():
    command = 'pulseaudio-ctl full-status'
    res = runCommand(command)
    s = res.split()
    vol = s[0]
    status = s[1]
    isMuted = True
    if status == 'no':
        isMuted = False
    return vol, isMuted

def toggle():
    command = 'pulseaudio-ctl mute'
    runCommand(command)

def buildStatusString():
    vol, isMuted = getStatus()
    symbol = 'x'
    strvol = vol + '%'
    if not isMuted:
        symbol = unmutedSymbol
    else:
        symbol = mutedSymbol 
    return ' '.join([symbol, strvol])

def adjustVolume(val):
    try:
        command = 'pulseaudio-ctl up'
        if val < 0:
            command = 'pulseaudio-ctl down'
            val *= -1
        command += ' ' + str(val)
        runCommand(command)
    except Exception as e:
        pass

if __name__ == "__main__":
    if len(sys.argv) < 2:
        exit(0)

    cmd = sys.argv[1]
    if cmd == 'adjust':
        adjustVolume(int(sys.argv[2]))
        updateStatusBar()
    elif cmd == 'read':
        print(buildStatusString())
    elif cmd == 'toggle':
        toggle()
        updateStatusBar()

