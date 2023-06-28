#!/usr/bin/python
import os
import sys
import urllib.request
import binascii

address = sys.argv[1]
fname = sys.argv[2]
otype = sys.argv[3]

qs = binascii.hexlify(open(fname, 'rb').read()).decode()
url = f'{address}/plantuml/{otype}/~h{qs}'
print(url)

try:
    resp = urllib.request.urlopen(url)
except Exception as ex:
    resp = ex
    # print(ex.read())
    # raise

with open(f'{fname}.{otype}', 'wb') as fd:
    fd.write(resp.read())
