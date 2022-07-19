#!/bin/bash

# build base container
docker build . --network host -f Dockerfile.base -t vhewes/nova:base

# compile test release in existing directory
if [ -d "./data" ]; then
  echo "data directory already exists, so using that."
else
  echo "no data directory found, copying from CVMFS."
  cp -r /cvmfs/nova.osgstorage.org/analysis/nux/nus22 data
fi

if [ ! -f "./.ssh/novakey" ]; then
  echo "ssh key at .ssh/novakey does not exist. you must create it before continuing."
  exit
fi

docker run -it --name nova-glibc-release --net=host -v $SSH_AUTH_SOCK:${SSH_AUTH_SOCK} -e SSH_AUTH_SOCK=${SSH_AUTH_SOCK} -v /cvmfs/fermilab.opensciencegrid.org:/cvmfs/fermilab.opensciencegrid.org -v /cvmfs/nova.opensciencegrid.org/:/cvmfs/nova.opensciencegrid.org -v /cvmfs/nova-development.opensciencegrid.org:/cvmfs/nova-development.opensciencegrid.org -v /cvmfs/nova.osgstorage.org:/cvmfs/nova.osgstorage.org -v $PWD/.ssh:/root/.ssh -v $PWD:/scratch vhewes/nova:base /bin/bash /scratch/install-release.sh

docker commit nova-glibc-release vhewes/nova:release
docker rm nova-glibc-release

docker build . --network host -f Dockerfile.production -t vhewes/nova:production

