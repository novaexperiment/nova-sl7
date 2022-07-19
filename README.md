# nova-sl7

This repo is for the [novaexperiment/sl7](https://hub.docker.com/r/novaexperiment/sl7) docker image. New commits will trigger rebuilds automatically.


Note: `novaexperiment/sl7:latest` is now based on `fermilab/fnal-wn-sl7`. The image is about twice the size of the previous version. The previous more compact image can be accessed via this tag: `novaexperiment/sl7:mini`.

## Building the custom glibc image

Building this image from scratch requires three stages:
- Build the base image.
- Create a container based on the base image, compile a release inside it, and commit the resulting release image.
- Build the production image based on the release image.

Most of these stages are automated. The user must first generate an SSH key, and then run the build script to build the image.

### Generating an SSH key

In order for a docker container to have access to the NOvA repository, an SSH key must be provided. To do so, run ```./gen-ssh-key.sh``` to generate a new key at `.ssh/novakey` which is used during the build. This script will also print the public key to the terminal - you MUST add this key to your account on github.com. Assuming your username is part of the novaexperiment group, this should give the build script access to the novasoft repository. If you skip this step, the build will fail.

Note that this mechanism generates the SSH key in a local directory, which is then mounted into the container while cloning and building the test release. At no point is the SSH key added or copied to the image directly, and UNDER NO CIRCUMSTANCES should this EVER be done. Placing an SSH key inside a docker image constitutes a major security risk -- even if the key is added and then later removed in your Dockerfile, it can still be extracted. Do not do this. I am serious.

### Building the image

Once you've generated an SSH key and added the public key to your github account, you can now build the image by running ```./build.sh```. This should run through the multi-stage process of building the production image. In order to mount the data directory inside the image, the script will copy the contents of the nus22 data directory in CVMFS to the current directory so it's accessible to the Dockerfile. In order to prevent needless repeated copies, the script will skip this step if a `data` directory already exists. If you wish to refresh the data directory at any point, simply remove `data` from the current directory, and the script will automatically trigger a new copy from CVMFS.

Running this script will generate three new tagged images: `vhewes/nova:base`, `vhewes/nova:release` and `vhewes/nova:production`, which correspond to the three build stages.

