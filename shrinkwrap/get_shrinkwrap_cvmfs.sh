#!/bin/bash

function process_args {    
    while getopts ":r:f:c:" opt; do
	if [ "$opt" == "-" ]; then
	    opt=$OPTARG
	fi
	case ${opt} in
	    r ) REPO=$OPTARG
		;;
	    f ) FILTER=$OPTARG
		;;
	esac
    done
    unset OPTARG
    unset opt
}

process_args $@

if [ "$REPO" == "nova.opensciencegrid.org" ]; then
    CONFIG=/shrinkwrap/nova.opensciencegrid.org.config
elif [ "$REPO" == "nova-development.opensciencegrid.org" ]; then
    CONFIG=/shrinkwrap/nova-development.opensciencegrid.org.config
else 
    echo "Repository $REPO not recognized"
    exit 1
fi

CVMFS_DIR=/cvmfs
SRC_CACHE=/shrinkwrap/cache

if [ -d $SRC_CACHE ]; then
    rm -rf $SRC_CACHE
fi

mkdir -p ${CVMFS_DIR} ${SRC_CACHE}
cd /shrinkwrap

/usr/bin/cvmfs_shrinkwrap --threads 20 --repo $REPO --src-cache $SRC_CACHE --dest-base $CVMFS_DIR --src-config $CONFIG --spec-file $FILTER

echo "Clearing cache"
rm -rf $SRC_CACHE
