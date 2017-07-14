#! /usr/bin/env python
from markdown import *
import sys

from subprocess import Popen, PIPE, check_output


def runCommand(command):
    return check_output(command, shell=True).decode(encoding='utf-8')

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Error: provide file name")
        exit(0)

    file_name = sys.argv[1]
    l = ''
    with open(file_name, 'r') as f:
        l = f.read()

    l = markdown(l, extensions=[
                          'markdown.extensions.extra', 'markdown.extensions.fenced_code', 'markdown.extensinos.codehilite'])

    output_file_name = file_name + '.html'
    with open(output_file_name, 'w') as f:
        f.write(l)

    runCommand('chromium ' + output_file_name)
