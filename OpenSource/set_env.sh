#!/bin/bash

# Author : Priyan Sureshbabu
# Email : priyanxmail@gmail.com
# Purpose : Set enviroenmnet variables for Python and Spark via graphical UI
# Dependency : whiptail
# Assumptions : Distribution - Hortonworks HDP(>2.5.x), Anaconda 2 & 3, Spark 1.6 and 2.x



if (whiptail --title "Hadoop Environment Set up" --yes-button "Ok" --no-button "Exit"  --yesno "Welcome Power User :),\n\nLet's set up your environment before you start using it!\n\n***Please note that you should run this script on a fresh shell. If you have to make changes after it's run, you should exit the current shell and start new one***\n\nChoose Ok to continue." 20 60) then
        echo ""
else
        return 0
fi

# Set Spark version

OPTION=$(whiptail --nocancel --title "Select Spark version" --menu "Which version of Spark do you want to use?" 15 60 4 \
"1" "Spark 2.x" \
"2" "Spark 1.x" 3>&1 1>&2 2>&3 )
exitstatus=$?
if [ $exitstatus = 0 ]; then
        if [ $OPTION = 1 ]; then
                export SPARK_HOME=/usr/hdp/current/spark2-client
                export SPARK_MAJOR_VERSION=2
        elif [ $OPTION = 2 ]; then
                export SPARK_HOME=/usr/hdp/current/spark-client
        else
                echo ""
        fi

else
        return 0
fi

# hdp-select is not supported by python 3. So, setting HDP version before it sets Anaconda 3

export HDP_VERSION=`hdp-select versions | tail -1`


OPTION=$(whiptail --nocancel --title "Select Anaconda/Python version for shell & PySpark" --menu "Which version of Anaconda/Python do you want to use?\n\nAnaconda 2 provides python 2.7 and Anaconda 3 provides python 3.6.\n\n***Please be advised that python 3 is not supported by a number of components in HDP, so it's safe to choose Anaconda 2 if you're not sure what you're doing.***\n\nThe version you select will be used for PySpark." 25 60 4 \
"1" "Anaconda 2" \
"2" "Anaconda 3" 3>&1 1>&2 2>&3 )
exitstatus=$?
if [ $exitstatus = 0 ]; then
        if [ $OPTION = 1 ]; then
                export PATH=/opt/anaconda2/bin:$PATH
                export export PYSPARK_PYTHON=/opt/anaconda2/bin/python
        elif [ $OPTION = 2 ]; then
                export PATH=/opt/anaconda3/bin:$PATH
                export export PYSPARK_PYTHON=/opt/anaconda3/bin/python
        else
                echo ""
        fi

else
        return 0
fi

# Set other variables

export HADOOP_CONF_DIR=/etc/hadoop/conf
export PYTHONPATH="${SPARK_HOME}/python:$PYTHONPATH"
export HIVE_HOME=/usr/hdp/current/hive-client
export PYTHONPATH=$(ls "$SPARK_HOME"/python/lib/py4j-*-src.zip):$PYTHONPATH
export SPARK_YARN_USER_ENV="PYTHONPATH=${PYTHONPATH}"

whiptail --title "Setup complete!" --msgbox "Congrats!\n\nYour Hadoop enviroenment has been set up. Below are the values set by this script -\n\nSPARK_HOME=$SPARK_HOME\nPYSPARK_PYTHON=$PYSPARK_PYTHON\nHADOOP_CONF_DIR=$HADOOP_CONF_DIR\nPYTHONPATH=$PYTHONPATH\nHDP_VERSION=$HDP_VERSION\nHIVE_HOME=$HIVE_HOME\nSPARK_YARN_USER_ENV=$SPARK_YARN_USER_ENV\n\nIf you want to modify any of these variables, please press \"Ok\", logout your curresnt session (putty), login back and re-launch the script.\n\nChoose Ok to exit the script. Happy Hadooping :) !" 35 80