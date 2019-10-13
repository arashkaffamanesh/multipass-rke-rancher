#!/bin/bash
multipass stop rke1 rke2 rke3
multipass delete rke1 rke2 rke3
multipass purge
rm hosts cluster.rkestate kube_config_cluster.yml get_helm.sh rke_darwin-amd64
echo "Please cleanup the host entries in your /etc/hosts manually"
