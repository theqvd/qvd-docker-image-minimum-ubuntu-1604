QVD minimal Docker image
========================

The base image used is Ubuntu 16.04, and this image only includes an xterm.

Support for LXC images
======================

This is how to build the minimal LXC image for QVD (if you don't have the Docker patch enabled)

To create the tar.gz file importable into QVD please use the following
commands:

  docker pull theqvd:qvdimageubuntu/minimalubuntu1604
  vmid=$(docker run -d -t -i theqvd/qvdimageubuntu:minimalubuntu1604 /bin/bash -c "read a; echo $a")
  docker export $vmid  | gzip -c > qvd-image-ubuntu-16.04-minimal.tgz
  sudo docker kill $vmid

And the importable image is qvd-image-ubuntu-16.04-minimal.tgz

To build the image run:

  sudo docker build -t theqvd:qvdimageubuntu/minimalubuntu1604 .


References
==========

More information about QVD can be found here: http://theqvd.com

Further docs are available here http://docs.theqvd.com
