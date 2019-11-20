#!/usr/bin/python
import string
from operator import xor
ip = raw_input('Enter IP: ')
a = ip.split('.')
c = ""
d = ""
for i in a:
	b = hex(xor(int(i), 0xff))
	b = b.replace ("0x", "")
	c = b + c
c = "0x" + c
print c
