#!/bin/bash

#Author : Priyan S

#Purpose : Run shell script and alert user(s) about the status
#Usage : /bin/bash launch_job.sh <script_file.sh> user@example.com

if [ "$#" -ne 2 ]; then
    printf "\033[1;31mERROR : Illegal number of parameters.\x1b[m\nSyntax : ./launch_job.sh <path_to_script> email\nExample : ./launch_job.sh /home/priyan/testScript.sh priyan@example.com\n"
    exit 1
fi

script=$1
email=$2

/bin/bash $script

if [ $? -eq 0 ]; then
        status="succesful"
else
        status="failed"
fi


SUBJECT="$script has been $status"
BODY="Hi, The script has been $status"

(echo EHLO localhost
echo MAIL FROM: launch_job@hadoop
echo RCPT TO: $email
echo "DATA
From: launch_job@hadoop
To: $email
Subject: $SUBJECT

$BODY"
echo '.'
echo QUIT) | nc smtp.server.hostname 25
