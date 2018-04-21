#!/usr/bin/python
import os
import sys
import ftplib

fname = sys.argv[1]
f = ftplib.FTP()
f.set_pasv(0)
f.connect('127.0.0.1', 4242)
f.login()
f.storlines('STOR boo.puml', sys.stdin.buffer)
f.retrbinary('RETR boo.svg', open(fname + '.tmp', 'wb').write)
f.quit()
os.rename(fname + '.tmp', fname)
