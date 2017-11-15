#!/bin/bash

# Author : Priyan S
# Purpose : Example script to kill yarn jobs owned by a user and send email alert
# USE : Copy This script to your home. Example : /home/priyan . Run this script as ./kill_yarn_jobs.sh <username>
# USE : To schedule this as a one time job at 1.00 PM TODAY, issue "at 1:00 PM" on linux shell
# > /usr/bin/sh /path/to/kill_yarn_jobs.sh <username>
# > Ctrl + D

if [ "$#" -ne 2 ]; then
    printf "\033[1;31mERROR : Illegal number of parameters.\x1b[m\nSyntax : ./kill_yarn_jobs.sh <username> <email>\nExample : ./kill_yarn_jobs.sh priyan priyan@example.com\n"
    exit 1
fi

USER=$1
EMAIL=$2

yarn application -list 2> /dev/null | grep $USER | grep application_ | awk {'print $1'} > /home/$USER/.cur_apps

wc=`cat /home/$USER/.cur_apps | wc -l`
if [ $wc -gt 0  ];then
        for i in `cat /home/$USER/.cur_apps`; do
                yarn application -kill $i
        done

SUBJECT="Following YARN jobs owned by $USER have been killed"
BODY=`cat /home/$USER/.cur_apps`

(echo EHLO localhost
echo MAIL FROM: kill_yarn_jobs@hadoop
echo RCPT TO: $EMAIL
echo "DATA
From: kill_yarn_jobs@hadoop
To: $EMAIL
Subject: $SUBJECT

$BODY"
echo '.'
echo QUIT) | nc smtp.mailserver.hostname 25

fi
