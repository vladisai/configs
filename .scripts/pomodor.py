#!/usr/bin/env python3
from enum import Enum
import time, sys
from subprocess import Popen, PIPE, check_output
import pickle

shortBreakDuration = 5 * 60
workSessionDuration = 25 * 60
sessionsForLongBreak = 4

workStatusChar = ''
shortBreakStatusChar = ''
pausedSymbol = ''

statusFile = '/home/vlad/.scripts/status'

class Status(Enum):
    inactive = 1
    working = 2
    shortBreak = 3

    def getDuration(self):
        if self is Status.inactive:
            return 0
        elif self is Status.working:
            return workSessionDuration
        elif self is Status.shortBreak:
            return shortBreakDuration

    def getCharacter(self):
        if self is Status.inactive:
            return ''
        elif self is Status.working:
            return workStatusChar
        elif self is Status.shortBreak:
            return shortBreakStatusChar

class Pomodor:
    status = Status.inactive
    lastOpened = 0
    sessions = 0
    isPaused = False
    timeElapsed = 0

    def updateTime(self):
        if not self.isPaused:
            self.timeElapsed += time.time() - self.lastOpened
        self.lastOpened = time.time()

    def startShortBreak(self):
        self.status = Status.shortBreak
        self.timeElapsed = 0

    def startWorkSession(self):
        self.status = Status.working
        self.timeElapsed = 0

    def toggle(self):
        if self.status is Status.inactive:
            self.startWorkSession()
        else:
            self.status = Status.inactive

    def togglePause(self):
        self.isPaused = not self.isPaused

    def buildStatusBarString(self):
        if self.status is Status.inactive:
            return ''
        else:
            timeLeft = self.status.getDuration() - self.timeElapsed
            res = self.status.getCharacter() + ' ' + getTimeString(timeLeft)
            if self.isPaused:
                res = pausedSymbol + ' ' + res
            res += ' ({})'.format(self.sessions)
            return res
        
    def update(self):
        self.updateTime()

        if self.status is Status.inactive:
            return

        if self.timeElapsed >= self.status.getDuration():
            if self.status is Status.working:
                    self.startShortBreak()
                    self.sessions += 1

            elif self.status is Status.shortBreak:
                self.startWorkSession()

    def resetSessions(self):
        self.sessions = 0

    def incSessions(self):
        self.sessions += 1

    def decSessions(self):
        self.sessions -= 1

    def __str__(self):
        return str(self.status) + ' elapsed:' + str(self.timeElapsed) + ' opened:' + str(self.lastOpened) + ' isPaused:' + str(self.isPaused) + ' sessions: {}'.format(self.sessions)

def runCommand(command):
    return check_output(command, shell = True).decode(encoding = 'utf-8')

def refresh():
    ret = runCommand('pkill -RTMIN+2 i3blocks')

def getTimeString(seconds):
    mins = int(seconds / 60)
    if mins > 0:
        return str(mins) + ' m'
    else:
        return '<1 m'

if __name__ == "__main__":

    timer = pickle.load(open(statusFile, 'rb'))
    timer.update()

    if len(sys.argv) < 2:
        exit(0)

    #print(str(timer))

    cmd = sys.argv[1]

    if cmd == 'read':
        print(timer.buildStatusBarString())
    if cmd == 'toggle':
        timer.toggle()
        refresh()
    if cmd == 'pause':
        timer.togglePause()
        refresh()
    if cmd == 'reset':
        timer.resetSessions()
        refresh()
    if cmd == 'inc':
        timer.incSessions()
        refresh()
    if cmd == 'dec':
        timer.decSessions()
        refresh()

    pickle.dump(timer, open(statusFile, 'wb'))
