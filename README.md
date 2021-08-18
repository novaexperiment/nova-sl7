# nova-sl7

This repo is for the [novaexperiment/sl7](https://hub.docker.com/r/novaexperiment/sl7) docker image. New commits will trigger rebuilds automatically.


Note: `novaexperiment/sl7:latest` is now based on `fermilab/fnal-wn-sl7`. The image is about twice the size of the previous version. The previous more compact image can be accessed via this tag: `novaexperiment/sl7:mini`.

`Dockerfile_mpichdiy` is moved to the `mpichdiy` branch. Automatic build&push is also set up for that branch for the image `novaexperiment/sl7:mpichdiy`. Please checkout and update that branch if you need to update the `mpichdiy` image.
