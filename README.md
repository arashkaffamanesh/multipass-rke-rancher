# Rancher Kubernetes Engine and Rancher Server on Multipass VMs (on Mac or Linux)

## Who should use this?

Those who'd like to get familiar with Rancher Kubernetes Engine and Rancher Server on their local machine using Multipass VMs.

## Prerequisites

Multipass
https://github.com/CanonicalLtd/multipass

This setup was tested on MacOS, but should work on Linux or Windows too.

## Installation

Clone this repo and run the scripts as follow:

```bash
git clone https://github.com/arashkaffamanesh/lxc-rke-rancher.git
cd lxc-rke-rancher/
./1-deploy-lxc-containers.sh
./2-deploy-rke.sh
# if you're a cert-manager lover, please provide the right domain name and email address in 3-deploy-rancher-on-rke.sh
./3-deploy-rancher-on-rke.sh
# open port 443 in your security group and map your domain in dns
```

## What you get

You should get a running RKE Cluster on 3 LXCs with Rancher Server on top in less than 20 minutes.

## Access the Rancher Server on RKE

https://your domain name

## Blog post

Blog post will be published on medium:

https://blog.kubernauts.io/


