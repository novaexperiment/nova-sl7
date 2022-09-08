#!/bin/bash

docker run -u root --name nova-shrinkwrap --net=host -e DIY_INC=/usr/local/diy/include \
  -v /cvmfs/fermilab.opensciencegrid.org:/cvmfs/fermilab.opensciencegrid.org \
  -v /cvmfs/nova.opensciencegrid.org:/cvmfs/nova.opensciencegrid.org \
  -v /cvmfs/nova-development.opensciencegrid.org:/cvmfs/nova-development.opensciencegrid.org \
  -v /cvmfs/nova.osgstorage.org:/cvmfs/nova.osgstorage.org \
  -v $PWD:/scratch -v $PWD/.ssh:/root/.ssh \
  novaexperiment/sl7:mpichdiy /scratch/scripts/shrinkwrap.sh
docker commit nova-shrinkwrap vhewes/nova:shrinkwrap
docker rm nova-shrinkwrap

