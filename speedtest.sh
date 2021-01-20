#!/bin/bash
##Author Gautham
##Date 18012021
TESTFILE='https://speed.hetzner.de/100MB.bin'
LOCATION='/tmp/speedtestfile'
TESTTIME='15'
## checking for network interface 
if [ -z "$1" ]; then
        echo
	echo usage: $0 network-interface
	echo
	echo e.g: bash $0 ETH01
	echo
	exit
fi

IF=$1
end=$((SECONDS+${TESTTIME}))
wget ${TESTFILE} -O ${LOCATION} &> /dev/null &
PID=$!
#echo
while true; do
	if [ -s "${LOCATION}" ]; then
	while [ $SECONDS -lt $end ];
		do
	
			R1=`cat /sys/class/net/$1/statistics/rx_bytes`
			T1=`cat /sys/class/net/$1/statistics/tx_bytes`
			sleep 1
       			R2=`cat /sys/class/net/$1/statistics/rx_bytes`
		        T2=`cat /sys/class/net/$1/statistics/tx_bytes`
		        TBPS=`expr $T2 - $T1`
		        RBPS=`expr $R2 - $R1`
		        TKBPS=`expr $TBPS / 1024`
		        RKBPS=`expr $RBPS / 1024`
		        echo "Uploaded $1: $TKBPS kB/s Downloaded $1: $RKBPS kB/s"
	done
	echo
	echo "Speed test completed"
	break;
	fi


done
kill -9 ${PID} &> /dev/null
rm -f ${LOCATION} &> /dev/null
