#!/bin/bash

usage() {
    /opt/bin/geriatrix
    exit 1
}

SIZE=""
UTILIZATION=0.8
AGE_DIST=/geriatrix/profiles/agrawal/age_distribution.txt
SIZE_DIST=/geriatrix/profiles/agrawal/size_distribution.txt
DIR_DIST=/geriatrix/profiles/agrawal/dir_distribution.txt
THREADS=1
ITERATIONS=100
CONFIDENCE=0
QUERY=0
RUN_TIME=2800

PARSED_ARGS=$(getopt -a -o n:u:t:i:a:s:d:c:qw: --long size:,utlization:,threads:,iterations:,age_distribution:,size_distribution:,dir_distribution:,confidence:,query,time: -- "$@")
if [ "$?" != "0" ]; then
     usage
fi

eval set -- "$PARSED_ARGS"

while [ true ]; do
    case "$1" in
 	-n | --size)
	    SIZE=$2
	    shift 2
 	    ;;
 	-u | --utilization)
 	    UTILIZATION=$2
	    shift 2
 	    ;;
 	-t | --threads)
 	    THREADS=$2
	    shift 2
 	    ;;
 	-i | --iterations)
 	    ITERATIONS=$2
	    shift 2
	    ;;
 	-a | --age_distribution)
 	    AGE_DIST=$2
	    shift 2
	    ;;
 	-s | --size_distribution)
 	    SIZE_DIST=$2
	    shift 2
	    ;;
 	-d | --dir_distribution)
 	    DIR_DIST=$2
	    shift 2
	    ;;
 	-c | --confidence)
	    CONFIDENCE=$2
	    shift 2
	    ;;
 	-q | --query)
	    QUERY=1
	    shift
	    ;;
 	-w | --time)
 	    RUN_TIME=$2
	    shift 2
	    ;;
	--)
	    shift
	    break
	    ;;
 	*)
 	    usage
	    ;;
    esac
done

if [ "$SIZE" = "" ]; then
    echo "Please specify size."
    usage
fi

echo -ne """Running aging with following configuration:

file_system_size: $((${SIZE} / 1024 / 1024))MB
goal_utilization: $UTILIZATION
num_threads: $THREADS
profiles:
\tage: $AGE_DIST
\tsize: $SIZE_DIST
\tdir: $DIR_DIST
num_iterations: $ITERATIONS
confidence: $CONFIDENCE
run_time: ${RUN_TIME}sec
query: $QUERY

Proceed? [y/N]: """

read cnf
if [ "$cnf" = "y" -o "$cnf" = "Y" ]; then
    /opt/bin/geriatrix -n $SIZE -u $UTILIZATION  -r 42 -m /mnt -a $AGE_DIST -s $SIZE_DIST  -d $DIR_DIST -x /tmp/age.out -y /tmp/size.out -z /tmp/dir.out -t $THREADS -i $ITERATIONS -f 0 -p 0 -c $CONFIDENCE -q $QUERY -w $RUN_TIME -b posix
else
    echo "Cancelled."
fi
