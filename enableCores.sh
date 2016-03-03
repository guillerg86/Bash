#!/bin/bash
################################################################
# File: enableCores.sh
# Author: Guille Rodriguez Gonzalez (guille.rodriguez.gonzalez@gmail.com).
# Date: 03/03/2016
# Description: Script that poweron/poweroff cores in Ubuntu/Debian.
# License: MIT
################################################################

NCORES=`cat /sys/devices/system/cpu/present | cut -d \- -f2`;
MAX=NCORES; 

if [ $# -eq 1 ];
then
	REGEXPATTERN='^[0-9]{1}[0-9]*$';
	if [[ $1 =~ $REGEXPATTERN ]]
	then
		ARG=`expr $1 - 1`
		if [ $ARG -gt $NCORES ]
		then
			MAX=$NCORES;
		else
			MAX=$ARG;
		fi

	else
		if [ "$1" == "MAX" ]
		then
			MAX=$NCORES;
		else
			echo -e "Usage: \n\tenableCores.sh NUMBER --> For activate some cores, if NUMBER is greater than real cores, all cores will be activated"
			echo -e "\tenableCores.sh MAX --> For activate all cores"
			exit -1;
		fi
	fi
	if [ $UID -eq 0 ]
	then 
		echo "Core 1: Activated"
		# ACTIVATING THE CORES THAT USER TELL - CORE 0 CAN'T BE DEACTIVATED
		for (( c=1; c<=$NCORES; c++))
		do
			if [ $c -le $MAX ]
			then
				echo "Core `expr $c + 1`: Activated";
				`echo 1 > /sys/devices/system/cpu/cpu$c/online`
			else
				echo "Core `expr $c + 1`: Deactivated";
				`echo 0 > /sys/devices/system/cpu/cpu$c/online`
			fi
		done
	else
		echo -e "\nYou need to run this script/command as root\n";
	fi
fi
