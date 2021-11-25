# Rancher Kubernetes Engine and Rancher Cluster Manager (2.6.2 Stable) on Multipass VMs with rootless Docker
![rke-rancher-nginx.png](rke-rancher-nginx.png)

## Who should use this?

Those Ops or sometimes Devs who'd like to get familiar with a full-fledged Rancher Kubernetes Engine (RKE) and Rancher Cluster Manager on their local machine using Multipass VMs to reduce their cloud costs.

This implementation uses a rootless docker and `mimikes` a near to production installation of RKE to host a Rancher Cluster Manager.

![#f03c15](https://via.placeholder.com/15/f03c15/000000?text=+) **NOTE: `This implementation is not tested on production environments!`** 

## Prerequisites

You need Multipass running on your local machine with mkcert and helm installed:

[multipass] https://multipass.run/

[mkcert](https://github.com/FiloSottile/mkcert)

[helm](https://helm.sh/docs/intro/install/)

This setup was tested on MacOS, but should work on Linux or maybe on Windows with WSL2 too.

This setup uses and was tested with the following tools and components:

* rke cli version v1.3.2
* kubectl version 1.20.9
* docker community version 20.10.7
* containerd version 1.4.9
* runc version 1.0.1
* mkcert version v1.4.1
* helm version v3.2.4

You need to have about 6GB RAM and 30GB storage on your local machine.

You need kubectl in your path, if not, you can download the v1.20.9 version and place it in your path:

MacOS users:

```bash
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.20.9/bin/darwin/amd64/kubectl
```

Linux users:

```bash
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.20.9/bin/linux/amd64/kubectl
```

```bash
chmod +x ./kubectl
mv kubectl /usr/local/bin/
```
### Important hint for linux users

Linux users should adapt the `create-hosts.sh` and change the network interface name. You can find the nic name with:

```bash
multipass launch --name test
multipass exec test -- bash -c 'echo `ls /sys/class/net | grep en`'
```

Delete and purge the test VM:

```bash
multipass delete test
multipass purge
```

If the above doesn't work somehow, shell into the node and get the nic name:

```bash
multipass shell test
ifconfig
```

![#f03c15](https://via.placeholder.com/15/f03c15/000000?text=+) **NOTE: `you need to provide your sudo password during the setup at your own risk, please study the scripts and don't trust me.`** 


Clone this repo and run the scripts as follow:

```bash
git clone https://github.com/arashkaffamanesh/multipass-rke-rancher.git
cd multipass-rke-rancher
./1-deploy-multipass-vms.sh
./2-deploy-rke.sh
# or with mkcert to get a vaild certificate (on macos), you need to install mkcert, pls. have a look in the script
./3-deploy-rancher-on-rke-mkcert-macos.sh
```

To deploy with a single command, please run:

```bash
./deploy.sh
```

## What you get

You should get a running RKE Cluster on 3 Multipass VMs with Rancher Server on top in about 20 minutes (depends on your CPU / internet speed and docker hub performance).

## Export KUBECONFIG

After installation your kubeconfig file will be placed in the installation folder, please run:

```
export KUBECONFIG=`pwd`/kube_config_cluster.yml
kubectl get all -A
```

**Tip**: use [Kubie](https://github.com/sbstp/kubie) to manage your clusters!

Kubie is an alternative to kubectx, kubens and the k on prompt modification script. 
## Access the Rancher Server on RKE

A tab will open in your browser and point to:

https://gui.rancher.svc/

## Install Metal-LB

Install Metal-LB to have support for service type LoadBalancer.

**Note:** Please adapt the ip range in `metal-lb-layer2-config.yaml` before running the `install-metal-lb.sh` script.

```bash
./install-metal-lb.sh
# Test the metal lb install with the custom built nginx server with self signed certificate and port 443 enabled:
# plese refer to the README.md under nginx-local-ssl
k create -f nginx-local-ssl/nginx-local-ssl.yaml
k get svc
## adapt the external ip in the command below
sudo -- sh -c "echo 192.168.64.18 nginx.local >> /etc/hosts"
curl -k https://nginx.local
```

## Clean Up

Cleanup your multipass VMs:

```bash
./cleanup-rkes.sh
```

## Blog post

Blog post will be published on medium:

https://blog.kubernauts.io/
