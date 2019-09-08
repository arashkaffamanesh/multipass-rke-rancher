# Rancher Kubernetes Engine and Rancher Server on Multipass VMs

## Who should use this?

Those who'd like to get familiar with Rancher Kubernetes Engine and Rancher Server on their local machine using Multipass VMs.

## Prerequisites

Multipass
https://github.com/CanonicalLtd/multipass

This setup was tested on MacOS, but should work on Linux or Windows too.

You need to have about 6GB RAM and 24GB storage on your local machine.

## Installation

### Install multipass (on MacOS or Linux)

```bash
brew cask install multipass
sudo snap install multipass --beta --classic
```

Clone this repo and run the scripts as follow:

```bash
git clone https://github.com/arashkaffamanesh/multipass-rke-rancher.git
cd multipass-rke-rancher
./1-deploy-multipass-vms.sh
./2-deploy-rke.sh
# if you're a cert-manager lover, please provide the right domain name and email address in 3-deploy-rancher-on-rke.sh
./3-deploy-rancher-on-rke.sh
```

## What you get

You should get a running RKE Cluster on 3 Multipass VMs with Rancher Server on top in about 30 minutes.

## Access the Rancher Server on RKE

https://rke1

## Clean Up

```bash
multipass stop rke1 rke2 rke3
multipass delete rke1 rke2 rke3
multipass purge
```

## Blog post

Blog post will be published on medium:

https://blog.kubernauts.io/


