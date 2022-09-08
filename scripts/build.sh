#!/bin/bash

# build base image
docker build . --network host --target base --tag vhewes/nova:base

# prepare analysis inputs
if [ -d "./data" ]; then
  echo "data directory already exists, so using that."
else
  echo "no data directory found, copying from CVMFS."
  cp -r /cvmfs/nova.osgstorage.org/analysis/nux/nus22 data
fi

# check SSH key
if [ ! -f "./.ssh/novakey" ]; then
  echo "ssh key at .ssh/novakey does not exist. you must create it before continuing."
  exit
fi

# build test release inside container
docker run --name nova-glibc-release --net=host \
  -v $SSH_AUTH_SOCK:${SSH_AUTH_SOCK} -e SSH_AUTH_SOCK \
  -v /cvmfs/fermilab.opensciencegrid.org:/cvmfs/fermilab.opensciencegrid.org \
  -v /cvmfs/nova.opensciencegrid.org/:/cvmfs/nova.opensciencegrid.org \
  -v /cvmfs/nova-development.opensciencegrid.org:/cvmfs/nova-development.opensciencegrid.org \
  -v /cvmfs/nova.osgstorage.org:/cvmfs/nova.osgstorage.org \
  -v $PWD/.ssh:/root/.ssh -v $PWD:/scratch \
  vhewes/nova:base /bin/bash /scratch/scripts/install-release.sh

# commit resulting container as image
docker commit nova-glibc-release vhewes/nova:release
docker rm nova-glibc-release

# build production image
docker build . --network host --target production --tag vhewes/nova:production

