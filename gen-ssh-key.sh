#!/bin/bash

echo
if (( $# != 1 )); then
  echo error: please pass your email address as an argument to this script
  echo
  exit
else
  echo using \"$1\" as email address
  echo
fi

if [ -d "./.ssh" ]; then
  echo warning: .ssh directory already exists! refusing to generate ssh key
  echo
  exit
fi

mkdir .ssh
ssh-keygen -t ed25519 -C "$1" -N "" -f .ssh/novakey

echo
echo ssh key generated. please add the public key to your github account:
echo
cat .ssh/novakey.pub
echo

