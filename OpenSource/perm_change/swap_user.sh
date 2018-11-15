#!/bin/bash

# Author : Priyan S
# Purpose : Update ownership of files and directories

for id in `cat /root/perm_change/uid`; 
	do 
	if [ `echo $id|cut -d : -f 2` -gt 900 ] 
	then
	echo $id 
	find / -uid `echo $id|cut -d : -f 2` -exec chown -h `echo $id|cut -d : -f 1` {} \;
	fi
done
