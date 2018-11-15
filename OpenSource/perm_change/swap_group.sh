#!/bin/bash

# Author : Priyan S
# Purpose : Update group permissions


for id in `cat /root/perm_change/gid`; 
	do 
	if [ `echo $id|cut -d : -f 2` -gt 900 ] 
	then
	echo $id 
	find / -gid `echo $id|cut -d : -f 2` -exec chgrp -h `echo $id|cut -d : -f 1` {} \;
	fi
done
